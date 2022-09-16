//
//  PostCreationViewController.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 6/6/22.
//

import UIKit

class PostCreationViewController: UIViewController, UITextFieldDelegate {

    private let postTitleInstructions: UILabel = {
        let pageTitle = UILabel()
        
        pageTitle.text = "Enter a post title."
        pageTitle.font = .systemFont(ofSize: 22, weight: .semibold)
        
        return pageTitle
    }()
    
    private let postTitle: UITextField = {
        let postTitle = UITextField()
        postTitle.backgroundColor = UIColor().qPurple
        postTitle.font = .systemFont(ofSize: 18, weight: .regular)
        postTitle.placeholder = "Enter a title."
        postTitle.layer.cornerRadius = 8.0
        return postTitle
    }()
    
    private let postDescriptionInstructions: UILabel = {
        let pageTitle = UILabel()
        
        pageTitle.text = "Enter a post description."
        pageTitle.font = .systemFont(ofSize: 22, weight: .semibold)
        
        return pageTitle
    }()
    
    private let postDescription: UITextField = {
        let postDescription = UITextField()
        postDescription.backgroundColor = UIColor().qPurple
        postDescription.font = .systemFont(ofSize: 18, weight: .regular)
        postDescription.placeholder = "Enter a description."
        postDescription.layer.cornerRadius = 8.0
        return postDescription
    }()
    
    private let postRatingInstructions: UILabel = {
        let pageTitle = UILabel()
        
        pageTitle.text = "Rate your chosen media."
        pageTitle.font = .systemFont(ofSize: 22, weight: .semibold)
        
        return pageTitle
    }()
    
    private let postRating: UISlider = {
        let postRating = UISlider()
        postRating.minimumValue = 0
        postRating.maximumValue = 10
        postRating.value = 0
        return postRating
    }()
    
    private let postRatingDisplay: UILabel = {
        let pageTitle = UILabel()
        
        pageTitle.text = "0"
        pageTitle.textAlignment = .center
        pageTitle.font = .systemFont(ofSize: 22, weight: .semibold)
        
        return pageTitle
    }()
    
    private let postMediaInstructions: UILabel = {
        let pageTitle = UILabel()
        
        pageTitle.text = "Choose your media."
        pageTitle.font = .systemFont(ofSize: 22, weight: .semibold)
        
        return pageTitle
    }()
    
    let postMediaButton: UIButton = {
        let postButton = UIButton()
        postButton.layer.masksToBounds = true
        postButton.layer.cornerRadius = 8.0
        postButton.setTitle("Tap here to search for media.", for: .normal)
        postButton.contentMode = .scaleAspectFill
        postButton.setTitleColor(UIColor.white, for: .normal)
        postButton.backgroundColor = UIColor().qPurple
        return postButton
    }()
    
    let finalizePostButton: UIButton = {
        let postButton = UIButton()
        postButton.layer.masksToBounds = true
        postButton.layer.cornerRadius = 8.0
        postButton.setTitle("Tap to create post!", for: .normal)
        postButton.contentMode = .scaleAspectFill
        postButton.setTitleColor(UIColor.white, for: .normal)
        postButton.backgroundColor = UIColor().qPurple
        return postButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postTitle.delegate = self
        self.postDescription.delegate = self
        
        view.backgroundColor = UIColor().qBlack
        
        view.addSubview(postTitleInstructions)
        view.addSubview(postTitle)
        view.addSubview(postDescriptionInstructions)
        view.addSubview(postDescription)
        view.addSubview(postRatingInstructions)
        view.addSubview(postRatingDisplay)
        view.addSubview(postRating)
        view.addSubview(postMediaInstructions)
        view.addSubview(postMediaButton)
        view.addSubview(finalizePostButton)
        
        postRating.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        postMediaButton.addTarget(self, action: #selector(launchSearch), for: .touchUpInside)
        finalizePostButton.addTarget(self, action: #selector(finalizePost), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        postTitleInstructions.sizeToFit()
        postTitleInstructions.frame = CGRect(x: 5, y: view.safeAreaInsets.bottom, width: view.width, height: postTitleInstructions.height)
        postTitle.sizeToFit()
        postTitle.frame = CGRect(x: 5, y: postTitleInstructions.bottom + 5, width: view.width - 10, height: postTitle.height + 10)
        
        
        postDescriptionInstructions.sizeToFit()
        postDescriptionInstructions.frame = CGRect(x: 5, y: postTitle.bottom + 10, width: view.width, height: postDescriptionInstructions.height)
        postDescription.sizeToFit()
        postDescription.frame = CGRect(x: 5, y: postDescriptionInstructions.bottom + 5, width: view.width - 10, height: postDescription.height + 10)
        
        postRatingInstructions.sizeToFit()
        postRatingInstructions.frame = CGRect(x: 5, y: postDescription.bottom + 10, width: view.width, height: postRatingInstructions.height)
        postRatingDisplay.sizeToFit()
        postRatingDisplay.frame = CGRect(x: 5, y: postRatingInstructions.bottom + 5, width: postRating.height, height: postRating.height)
        postRating.sizeToFit()
        postRating.frame = CGRect(x: postRatingDisplay.right + 5, y: postRatingInstructions.bottom + 5, width: view.width - 10 - postRatingDisplay.right, height: postRating.height + 10)
        
        postMediaInstructions.sizeToFit()
        postMediaInstructions.frame = CGRect(x: 5, y: postRating.bottom + 10, width: view.width - 10, height: postMediaInstructions.height)
        postMediaButton.sizeToFit()
        postMediaButton.frame = CGRect(x: 5, y: postMediaInstructions.bottom + 5, width: view.width - 10, height: 60)
        
        finalizePostButton.sizeToFit()
        finalizePostButton.frame = CGRect(x: 5, y: postMediaButton.bottom + 10, width: view.width - 10, height: 60)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func sliderValueDidChange(_ sender: UISlider!) {
        let roundedStepValue = round(sender.value)
        sender.value = roundedStepValue
        
        postRatingDisplay.text = String(describing: Int(sender.value))
    }
    
    var timer: Timer = Timer()
                                  
    @objc func launchSearch() {
        var search = SearchViewController(shouldPresentChoice: false)
        
        present(search, animated: true)
        
        let aTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            if(search.didChoose) {
                if(search.chosenAlbum != nil) {
                    self!.type = "album"
                    self!.chosenAlbum = search.chosenAlbum
                }
                else if(search.chosenTrack != nil) {
                    self!.type = "track"
                    self!.chosenTrack = search.chosenTrack
                }
                else {
                    self!.type = "artist"
                    self!.chosenArtist = search.chosenArtist
                }
            }
        }
        
        timer = aTimer
    }
    
    @objc func finalizePost() {
        if(postTitle.text != "" && postDescription.text != "" && type != nil) {
            switch (type) {
                case "track":
                FirebaseManager.shared.pushUserPost(post: SocialPostModel(title: postTitle.text!, description: postDescription.text!, date: Date.now, media: chosenTrack!, rating: Int(postRating.value)))
                case "album":
                FirebaseManager.shared.pushUserPost(post: SocialPostModel(title: postTitle.text!, description: postDescription.text!, date: Date.now, media: chosenAlbum!, rating: Int(postRating.value)))
                case "artist":
                FirebaseManager.shared.pushUserPost(post: SocialPostModel(title: postTitle.text!, description: postDescription.text!, date: Date.now, media: chosenArtist!, rating: Int(postRating.value)))
                default:
                    return
            }
            
            dismiss(animated: true)
            timer.invalidate()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()	
    }
    
    private var type: String?
    public var chosenArtist: ArtistModel?
    public var chosenTrack: TrackModel?
    public var chosenAlbum: AlbumModel?
}
