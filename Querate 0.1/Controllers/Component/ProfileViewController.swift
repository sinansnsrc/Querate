//
//  ProfileViewController.swift
//  Querate 0.1
//
//  Created by Sinan Sensurucu on 2/22/22.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let profileTableView: UITableView = {
        let profileTableView = UITableView()
        profileTableView.backgroundColor = UIColor().qBlue
        profileTableView.isHidden = true
        
        profileTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return profileTableView
    }()
    
    private let titleText: UITextView = {
        let titleText = UITextView()
        
        titleText.text = "Profile."
        titleText.font = UIFont(name: titleText.font!.fontName, size: 36)
        titleText.backgroundColor = UIColor().qBlue
        titleText.textColor = .white

        return titleText
    }()
    
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        getProfile()
        
        view.backgroundColor = UIColor().qBlue
        view.addSubview(titleText)
        view.addSubview(profileTableView)
    }
    
    private func getProfile() {
        APIManager.shared.getUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(model: model)
                case .failure(let error):
                    self?.failedToGetProfile()
                }
            }
        }
    }
    
    private func updateUI(model: UserModel) {
        models.append("Name: \(model.display_name)")
        models.append("Email: \(model.email)")
        models.append("ID: \(model.id)")
        models.append("Plan: \(model.product)")
        //models.append("Explicit Content Allowed: \(model.explicit_content)")
        
        profileTableView.reloadData()
        
        profileTableView.isHidden = false
        
    }
    
    private func failedToGetProfile() {
        let failure = UILabel()
        failure.text = "Failed to load profile."
        failure.sizeToFit()
        failure.textColor = .white
        view.addSubview(failure)
        failure.center = view.center
    }
    
    override func viewDidLayoutSubviews() {
        titleText.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.width - 40, height: 100)
        profileTableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 50, width: view.width, height: view.height - 50 - view.safeAreaInsets.top)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

}
