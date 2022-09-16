//
//  AuthenticationViewController.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 2/22/22.
//

import UIKit
import WebKit

class AuthenticationViewController: UIViewController, WKNavigationDelegate {

    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let configurations = WKWebViewConfiguration()
        configurations.defaultWebpagePreferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: configurations)
        return webView
    }()
    
    public var signInComplete: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign in using Spotify."
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = AuthenticationManager.shared.signInURL else {
            return
        }
        
        webView.load(URLRequest(url: url))
        
        print("* - Presenting sign in screen.")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        
        print("* - Code recieved from URI redirect.")
        
        webView.isHidden = true
        
        AuthenticationManager.shared.exchangeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.signInComplete?(success)
            }
        }
    }
}
