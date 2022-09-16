//
//  WelcomeViewController.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 2/22/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let signInButton = UIButton()
        
        signInButton.backgroundColor = UIColor().qGreen
        signInButton.setTitle("Sign in with Spotify.", for: .normal)
        signInButton.setTitleColor(UIColor().qBlue, for: .normal)

        return signInButton
    }()
    
    private let pageDescription: UILabel = {
        let pageDescription = UILabel()
        
        pageDescription.text = "Queue.\nRate.\nCurate.\n\nMade by Sinan Sensurucu."
        pageDescription.numberOfLines = 5
        pageDescription.font = .systemFont(ofSize: 28, weight: .semibold)
        
        return pageDescription
    }()

    private let pageTitle: UILabel = {
        let pageTitle = UILabel()
        
        pageTitle.text = "Welcome to Curate."
        pageTitle.font = .systemFont(ofSize: 36, weight: .bold)
        
        return pageTitle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor().qBlack
        
        view.addSubview(pageTitle)
        view.addSubview(pageDescription)
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageTitle.sizeToFit()
        pageTitle.frame = CGRect(x: 5, y: (view.height / 3) - (pageTitle.height / 2), width: view.width, height: pageTitle.height)
        
        pageDescription.sizeToFit()
        pageDescription.frame = CGRect(x: 5, y: pageTitle.bottom + 10, width: view.width, height: pageDescription.height)
        
        signInButton.frame = CGRect(x: 10, y: pageDescription.bottom + 20, width: view.width - 20, height: 60)
        signInButton.layer.cornerRadius = 30
    }
    
    @objc func didTapSignIn() {
        let authenticationScreen = AuthenticationViewController()
        authenticationScreen.signInComplete = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        
        authenticationScreen.navigationItem.largeTitleDisplayMode = .never
        present(authenticationScreen, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else {
            let failureAlert = UIAlertController(title: "Couldn't sign in.", message: "Something went wrong when signing in.", preferredStyle: .alert)
            failureAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(failureAlert, animated: true)
            print("* - Failed to sign user in.")
            return
        }
        
        let mainAppPageViewController = PageViewController()
        mainAppPageViewController.modalPresentationStyle = .fullScreen
        dismiss(animated: true)
        present(mainAppPageViewController, animated: true)
    }
}
