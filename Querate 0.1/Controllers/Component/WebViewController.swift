//
//  WebViewController.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 6/6/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let configurations = WKWebViewConfiguration()
        configurations.defaultWebpagePreferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: configurations)
        return webView
    }()
    
    var pageTitle: String!
    var url: URL!
    
    init(pageTitle: String, url: URL) {
        super.init(nibName: nil, bundle: nil)
        
        self.pageTitle = pageTitle
        self.url = url
    }
    
    override func viewWillLayoutSubviews() {
        webView.frame = view.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        
        title = pageTitle
        webView.navigationDelegate = self
        
        webView.load(URLRequest(url: url))
    }
}
