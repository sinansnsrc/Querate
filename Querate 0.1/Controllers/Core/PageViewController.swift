import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
        
    var screens = [UIViewController]()
    let toolBar: UIView = {
        let toolBar = UIView()
        toolBar.layer.borderWidth = 1.5
        toolBar.layer.borderColor = UIColor.white.cgColor
        toolBar.clipsToBounds = true
        toolBar.layer.cornerRadius = 8.0
        toolBar.backgroundColor = UIColor().qBlack
        return toolBar
    }()
    
    let searchButton: UIButton = {
        let searchButton = UIButton()
        searchButton.layer.masksToBounds = true
        searchButton.layer.cornerRadius = 8.0
        let config = UIImage.SymbolConfiguration(pointSize: 40)
        searchButton.setImage(UIImage(systemName: "magnifyingglass.circle.fill", withConfiguration: config), for: .normal)
        searchButton.contentMode = .scaleAspectFill
        searchButton.tintColor = UIColor().qBlack
        searchButton.backgroundColor = UIColor.white
        return searchButton
    }()
    
    let discoverButton: UIButton = {
        let discoverButton = UIButton()
        discoverButton.layer.masksToBounds = true
        discoverButton.layer.cornerRadius = 8.0
        let config = UIImage.SymbolConfiguration(pointSize: 35)
        discoverButton.setImage(UIImage(systemName: "person.fill.questionmark", withConfiguration: config), for: .normal)
        discoverButton.contentMode = .scaleAspectFill
        discoverButton.tintColor = UIColor().qBlack
        discoverButton.backgroundColor = UIColor.white
        return discoverButton
    }()
    
    let postButton: UIButton = {
        let postButton = UIButton()
        postButton.layer.masksToBounds = true
        postButton.layer.cornerRadius = 8.0
        let config = UIImage.SymbolConfiguration(pointSize: 35)
        postButton.setImage(UIImage(systemName: "plus.bubble.fill", withConfiguration: config), for: .normal)
        postButton.contentMode = .scaleAspectFill
        postButton.tintColor = UIColor().qBlack
        postButton.backgroundColor = UIColor.white
        return postButton
    }()
    
    let userActivityDisplay: UILabel = {
        let pageTitle = UILabel()
        
        pageTitle.font = .systemFont(ofSize: 16, weight: .bold)
        pageTitle.backgroundColor = .white
        pageTitle.layer.cornerRadius = 8.0
        pageTitle.layer.masksToBounds = true
        pageTitle.textColor = UIColor().qBlack
        
        pageTitle.text = ""
        pageTitle.textAlignment = .center
        
        return pageTitle
    }()
    
    init() {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let libraryScreen = LibraryViewController()
        screens.append(libraryScreen)
        
        let socialScreen = SocialViewController()
        screens.append(socialScreen)
        
        let feedScreen = FeedViewController()
        screens.append(feedScreen)
        
        let curationScreen = CurationViewController()
        screens.append(curationScreen)
        
        let browseScreen = BrowseViewController()
        screens.append(browseScreen)
        
        let settingsScreen = SettingsViewController()
        screens.append(settingsScreen)
        
        dataSource = self
        
        setViewControllers([screens[2]], direction: .forward, animated: true, completion: nil)
        
        searchButton.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        postButton.addTarget(self, action: #selector(didTapPost), for: .touchUpInside)
        
        toolBar.addSubview(searchButton)
        toolBar.addSubview(discoverButton)
        toolBar.addSubview(postButton)
        toolBar.addSubview(userActivityDisplay)
        view.addSubview(toolBar)
    }
    
    @objc func didTapSearch() {
        present(SearchViewController(shouldPresentChoice: true), animated: true)
    }
    
    @objc func didTapPost() {
        present(PostCreationViewController(), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        toolBar.frame = CGRect(x:5, y: view.bottom - 100, width: view.width - 10, height: 70)
        searchButton.frame = CGRect(x: view.width - 75, y: 5, width: toolBar.frame.height - 10, height: toolBar.frame.height - 10)
        discoverButton.frame = CGRect(x: view.width - 140, y: 5, width: toolBar.frame.height - 10, height: toolBar.frame.height - 10)
        postButton.frame = CGRect(x: view.width - 205, y: 5, width: toolBar.frame.height - 10, height: toolBar.frame.height - 10)
        userActivityDisplay.sizeToFit()
        
        userActivityDisplay.frame = CGRect(x: 5, y: 5, width: view.width - postButton.left - 30, height: toolBar.frame.height - 10)
        
        var timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            APIManager.shared.getPlaybackState { result in
                switch result {
                case .success(let model):
                    if(model.is_playing) {
                        DispatchQueue.main.async {
                            self!.userActivityDisplay.text = "Currently active."
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self!.userActivityDisplay.text = "Currently not active."
                        }
                    }
                case .failure(let model):
                    break
                }
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = screens.firstIndex(of: viewController), index > 0 else {
            return nil
        }
                
        return screens[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = screens.firstIndex(of: viewController), index < (screens.count - 1) else {
            return nil
        }
                
        return screens[index + 1]
    }

}
