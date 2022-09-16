import UIKit
import Foundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        URLCache.shared.removeAllCachedResponses()
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        FirebaseManager.shared.configureFirebase()
        FirebaseManager.shared.configureDatabase()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        if(AuthenticationManager.shared.userIsSignedIn) {
            print("* - User access token (for console): \(UserDefaults.standard.string(forKey: "access_token")!)")
            window.rootViewController = PageViewController()
        }
        else {
            let welcomeScreen = UINavigationController(rootViewController: WelcomeViewController())
            window.rootViewController = welcomeScreen
        }

        window.makeKeyAndVisible()
        self.window = window
        
        print("* - User activity push loop started, will push to database every 5 seconds until app close.")
        var timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            FirebaseManager.shared.pushUserInformation()
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

