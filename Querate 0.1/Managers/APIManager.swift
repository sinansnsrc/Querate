//
//  APIManager.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 2/22/22.
//

import Foundation

final class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    //GET Methods
    public func getUserProfile(completion: @escaping (Result<UserModel, Error>) -> Void) {
        createRequestBase(with: URL(string: Constants.baseAPIURL + "/me"), type: .GET) { requestBase in
            let task = URLSession.shared.dataTask(with: requestBase) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserModel.self, from: data)
                    print("* - User profile successfully retreived.")
                    completion(.success(result))
                }
                
                catch {
                    print("* - Failed to retreive user profile.")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getNewReleases(completion: @escaping ((Result<NewReleasesModel, Error>)) -> Void) {
        createRequestBase(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?limit=20"), type: .GET) { requestBase in
            let task = URLSession.shared.dataTask(with: requestBase) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleasesModel.self, from: data)
                    print("* - New releases successfully retreived.")
                    completion(.success(result))
                }
                
                catch {
                    print("* - Failed to retreive new releases.")
                    completion(.failure(error))
                }
            }
            task.resume()
            
        }
    }
    
    public func getFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistsModel, Error>)) -> Void) {
        createRequestBase(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=20"), type: .GET) { requestBase in
            let task = URLSession.shared.dataTask(with: requestBase) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsModel.self, from: data)
                    print("* - Featured playlists successfully retreived.")
                    completion(.success(result))
                }
                
                catch {
                    print("* - Failed to retreive featured playlists.")
                    completion(.failure(error))
                }
            }
            task.resume()
            
        }
    }
    
    public func getUserPlaylists(completion: @escaping ((Result<UserPlaylistsResponse, Error>)) -> Void) {
        createRequestBase(with: URL(string: Constants.baseAPIURL + "/me/playlists?limit=20"), type: .GET) { requestBase in
            let task = URLSession.shared.dataTask(with: requestBase) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserPlaylistsResponse.self, from: data)
                    print("* - User playlists successfully retreived.")
                    completion(.success(result))
                }
                
                catch {
                    print("* - Failed to retreive user playlists.")
                    completion(.failure(error))
                }
            }
            task.resume()
            
        }
    }
    
    public func getSearchQuery(query: String, completion: @escaping ((Result<SearchModel, Error>)) -> Void) {
        let modQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        print("* - Getting search results for query: \"\(modQuery!)\".")
        
        createRequestBase(with: URL(string: Constants.baseAPIURL + "/search?q=\(modQuery!)&type=track%2Cartist%2Calbum%2Cplaylist&limit=6"), type: .GET) { requestBase in
            let task = URLSession.shared.dataTask(with: requestBase) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    print("* - Failed to retreive search results.")
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SearchModel.self, from: data)
                    print("* - Search results successfully retreived.")
                    completion(.success(result))
                }
                
                catch {
                    print("* - Failed to retreive search results.")
                    completion(.failure(error))
                }
            }
            task.resume()
            
        }
    }
    
    public func getPlaybackState(completion: @escaping ((Result<CurrentlyPlayingRequestModel, Error>)) -> Void) {
        createRequestBase(with: URL(string: Constants.baseAPIURL + "/me/player/currently-playing"), type: .GET) { requestBase in
            let task = URLSession.shared.dataTask(with: requestBase) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    //let a = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    //print(a)
                    let result = try JSONDecoder().decode(CurrentlyPlayingRequestModel.self, from: data)
                    //print("* - Currently playing successfully retreived.")
                    completion(.success(result))
                }
                
                catch {
                    //	print("* - Failed to retreive currently playing.")
                    completion(.failure(error))
                }
            }
            task.resume()
            
        }
    }
    
    public func getAlbumDetails(album: AlbumModel, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequestBase(with: URL(string: Constants.baseAPIURL + "/albums/\(album.id)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(json))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getPlaylistDetails(playlist: PlaylistModel, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
        createRequestBase(with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let json = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(json))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    //POST Methods
    public func createPlaylist(name: String, description: String? = "Created in Querate.", completion: @escaping ((Result<PlaylistCreationResponse, Error>)) -> Void) {
        getUserProfile { result in
            switch result {
            case .success(let profile):
                let userID = profile.id
                
                self.createRequestBase(with: URL(string: Constants.baseAPIURL + "/users/\(userID)/playlists"), type: .POST) { base in
                    var requestBase = base
                    let requestBody = [
                        "name": name,
                        "public": false,
                        "collaborative": false,
                        "description": description
                    ] as [String : Any]
                    requestBase.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: .fragmentsAllowed)

                    let task = URLSession.shared.dataTask(with: requestBase) { data, _, error in
                        guard let data = data, error == nil else {
                            completion(.failure(APIError.failedToGetData))
                            return
                        }
                        
                        do {
                            let result = try JSONDecoder().decode(PlaylistCreationResponse.self, from: data)
                            print("* - Successfully created new playlist.")
                            completion(.success(result))
                        }
                        
                        catch {
                            print("* - Failed to create new playlist.")
                            completion(.failure(APIError.failedToGetData))
                        }
                    }
                    task.resume()
                    
                }
                
            case .failure(let profile):
                break
            }
        }
    }
    
    //Base Methods
    private func createRequestBase(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        AuthenticationManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 60
            
            
            completion(request)
        }
    }
    
    
}
