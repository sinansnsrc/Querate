//
//  SettingsViewController.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 2/22/22.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var sections = [Section]()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.backgroundColor = UIColor().qBlack
        
        return tableView
    }()
    
    private let pageIndicator: UILabel = {
        let pageIndicator = UILabel()
        
        pageIndicator.backgroundColor = UIColor().qBlack
        
        pageIndicator.layer.masksToBounds = true
        pageIndicator.layer.cornerRadius = 8.0
        
        return pageIndicator
    }()
    
    private let pageTitle: UILabel = {
        let pageTitle = UILabel()
        
        pageTitle.text = "Settings."
        pageTitle.font = .systemFont(ofSize: 40, weight: .bold)
        
        return pageTitle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor().qBlack
        
        configureModels()
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(pageTitle)
        view.addSubview(pageIndicator)
        view.addSubview(tableView)
    }
    
    func configureModels() {
        sections.append(Section(title: "Profile", options: [Option(title: "View Profile", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.viewProfile() 
            }
        })]))
        sections.append(Section(title: "Account", options: [Option(title: "Sign Out", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.signOutTapped()
            }
        })]))
    }
    
    private func signOutTapped() {
        let signOutAlert = UIAlertController(title: "Sign out?", message: "Are you sure? You will need to sign in again before using Querate.", preferredStyle: .alert)
        signOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        signOutAlert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { _ in
            AuthenticationManager.shared.signOut() { [weak self] signedOut in
                if signedOut {
                    DispatchQueue.main.async {
                        let welcomeScreen = UINavigationController(rootViewController: WelcomeViewController())
                        welcomeScreen.navigationBar.prefersLargeTitles = true
                        welcomeScreen.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                        welcomeScreen.modalPresentationStyle = .fullScreen
                        self?.present(welcomeScreen, animated: true, completion: nil)
                    }
                }
            }
        }))
        
        present(signOutAlert, animated: true)
    }
    
    func viewProfile() {
        let profileScreen = ProfileViewController()
        present(profileScreen, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pageTitle.sizeToFit()
        pageTitle.frame = CGRect(x: 5, y: view.safeAreaInsets.top, width: view.width, height: pageTitle.height)

        tableView.frame = CGRect(x: 0, y: pageTitle.bottom, width: view.width, height: view.height - 50 - view.safeAreaInsets.top)
        pageIndicator.frame = CGRect(x: 0, y: 0, width: view.width, height: view.safeAreaInsets.top)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title
    }
}
