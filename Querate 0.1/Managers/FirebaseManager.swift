//
//  FirebaseManager.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 4/5/22.
//

import Foundation
import Firebase
import FirebaseDatabase

final class FirebaseManager {
    static let shared = FirebaseManager()
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    var ref: DatabaseReference!
    
    public func configureFirebase() {
        FirebaseApp.configure()
    }
    
    public func configureDatabase() {
        ref = Database.database(url: "https://querate-e44eb-default-rtdb.europe-west1.firebasedatabase.app/").reference()
    }
    
    public func pushUserInformation() {
        APIManager.shared.getUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self!.ref.child("users/\(UserDefaults.standard.value(forKey: "user_id")!)/information").observeSingleEvent(of: .value) { (snapshot) in
                        if(snapshot.exists()) {
                            print("* - User data not pushed, already exists.")
                        }
                        else {
                            let userInfo: [String: Any] = [
                                "email": model.email,
                                "product": model.product,
                                "name": model.display_name,
                                "country": model.country,
                                "profile_picture": model.images.first?
                                    .url ?? "https://i.scdn.co/image/ab6775700000ee85866e531bfd68501894ed8d26",
                            ]
                            
                            self!.ref.child("users/\(UserDefaults.standard.value(forKey: "user_id")!)/information").setValue(userInfo)
                            print("* - User activity successfully pushed to database.")
                        }
                    }
                case .failure(let error):
                    print("* - Failed to push user information to the database.")
                }
            }
        }
    }
    
    public func pushUserActivity() {
        APIManager.shared.getPlaybackState { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    let date = Date()
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: date)
                    let minutes = calendar.component(.minute, from: date)
                    
                    let userActivity: [String: Any] = [
                        "name": model.item.name,
                        "artist(s)": model.item.artists.map { $0.name }.joined(separator: ", "),
                        "album": model.item.album.name,
                        "popularity": model.item.popularity,
                        "progress": model.item.duration_ms,
                        "time": "\(hour):\((String(describing: minutes).count == 1 ? "0\(minutes)" : "\(minutes)"))",
                        "media": model.item.album.images.first?.url
                    ]
                    
                    self!.ref.child("activity/\(UserDefaults.standard.value(forKey: "user_id")!)").setValue(userActivity)

                    //print("* - User activity pushed to database.")
                case .failure(let model):
                    //print("* - Failed to push user activity to the database. User may not be active right now.")
                    return
                }
            }
        }
    }
    
    public func pushUserPost(post: SocialPostModel) {
        if(post.description.isEmpty || post.title.isEmpty) {
            print("* - Post not pushed, missing necessary elements.")
            return
        }
        else {
            var track_name = ""
            var artists = ""
            var album = ""
            var media = ""
            
            switch(post.type) {
            case "track":
                track_name = post.track!.name
                artists = post.track!.artists.map { $0.name }.joined(separator: ", ")
                album = post.track!.album!.name
                media = (post.track?.album?.images.first!.url)!
            case "album":
                artists = post.album!.artists.map { $0.name }.joined(separator: ", ")
                album = post.album!.name
                media = (post.album?.images.first!.url)!
            case "artist":
                artists = post.artist!.name
                media = (post.artist?.images!.first!.url)!
                
            default:
                print("* - Invalid media type, not pushed to database.")
                return
            }
            
            let format = "MMM d, HH:mm"
            
            let dateformat = DateFormatter()
            dateformat.dateFormat = format
            
            let userPost: [String: Any] = [
                "title": post.title,
                "description": post.description,
                "rating": post.rating,
                "type": post.type,
                "track_name": track_name,
                "artist(s)": artists,
                "album": album,
                "date": dateformat.string(from: post.date),
                "media": media
            ]
            
            self.ref.child("posts/\(UserDefaults.standard.value(forKey: "user_id")!)/\(post.date)").setValue(userPost)
            
            print("* - Post pushed to database.")
        }
    }
    

    
    public func fetchUsers(completion: @escaping([String]) -> ()) {
        var users = [String]()
        
        ref.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("* - Failed to fetch users from database.")
                return
            }
            
            for user in value.keys {
                users.append(user as String)
            }

            completion(users)
        })
    }
    
    public func fetchPosts(completion: @escaping([FeedPostCellViewModel]) -> ()) {
        var posts = [FeedPostCellViewModel]()
        let group = DispatchGroup()
        
        group.enter()
        self.fetchUsers() { users in
            for user in users {
                group.enter()
                self.ref.child("posts/\(user)").observeSingleEvent(of: .value, with: { snapshot in
                    guard let value = snapshot.value as? [String: Any] else {
                        print("* - Failed to fetch user posts from database.")
                        group.leave()
                        return
                    }
                    
                    for title in value.keys {
                        group.enter()
                        self.ref.child("posts/\(user)/\(title)").observeSingleEvent(of: .value, with: { otherSnapshot in
                            guard let otherValue = otherSnapshot.value as? [String: Any] else {
                                print("* - Failed to fetch user post titles from database.")
                                group.leave()
                                return
                            }
                            
                            posts.append(FeedPostCellViewModel(user: user, date: otherValue["date"] as! String, title: otherValue["title"] as! String, description: otherValue["description"] as! String, rating: otherValue["rating"] as! Int, media: otherValue["media"] as! String, track: otherValue["track_name"] as! String, artist: otherValue["artist(s)"] as! String, album: otherValue["album"] as! String, type: otherValue["type"] as! String))
                            group.leave()
                        })
                    }
                    group.leave()
                })
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(posts)
        }
    }
    
    public func fetchActivities(completion: @escaping([FriendActivityCellViewModel]) -> ()) {
        var activities = [FriendActivityCellViewModel]()
        let group = DispatchGroup()
        
        group.enter()
        self.fetchUsers { users in
            for user in users {
                group.enter()
                self.ref.child("activity/\(user)").observeSingleEvent(of: .value, with: { snapshot in
                    guard let value = snapshot.value as? [String: Any] else {
                        print("* - Failed to fetch user activities from database.")
                        group.leave()
                        return
                    }
                    
                    activities.append(FriendActivityCellViewModel(friendName: user, songName: value["name"] as! String, time: value["time"] as! String, artist: value["artist(s)"] as! String, album: value["album"] as! String, media: value["media"] as! String))
                    group.leave()
                })
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(activities)
        }
    }
}
