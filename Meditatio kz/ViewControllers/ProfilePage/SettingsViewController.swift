//
//  SettingsViewController.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/15/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var allowNotification: Bool = false
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ParameterCell.self, forCellReuseIdentifier: ParameterCell.name)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    //MARK: -Initializers
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Параметрлер"
        setupViews()
        setupLayout()
    }
    
    func setupViews() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubViews(views: [tableView])
    }
    
    func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationItem.largeTitleDisplayMode = .always
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ParameterCell.name, for: indexPath) as! ParameterCell
        let menuOption = ParametersOption.init(rawValue: indexPath.row)
        cell.mainLabel.text = menuOption?.description
        cell.cursorView.image = menuOption?.cursorPhoto
        if indexPath.row == 2 {
            cell.cursorView.isHidden = true
            cell.switchOnOff.isHidden = false
            cell.delegateValue = self
            print(allowNotification)
            cell.switchOnOff.setOn(allowNotification, animated: false)
            
        }
        cell.mainLabel.text = menuOption?.description
        cell.cursorView.image = menuOption?.cursorPhoto
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
                
        let row = indexPath.row
        let menuOption = ParametersOption.init(rawValue: row)
        
        if row == 2 {
            print("Hello")
        } else if row == 3 {
            "Data to share".share()
            
        } else if row == 4{
            StorageManager.shared.removeSavedData()
            appDelegate.navigateToLoginViewController()
        } else {
            let vc = menuOption?.viewControllers
            vc?.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController( (vc)!, animated: true)
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height * 0.08
    }
}

extension SettingsViewController: NotificationSwitch  {
    func valueChange(_ value: Bool) {
        guard let token = StorageManager.shared.token else {
            print("Error in ProfilePage, no user data (token)")
            return
        }
        
        let parameters = ["allow_notifications": value]
        networkManager.makeRequest(endpoint: Endpoints.changeAboutMe(token: token, params: parameters)) { (result: Result<ProfileData>) in
                       print("Hello", result)
            switch result {
               case .failure(let errorMessage):
                   print(errorMessage)
                   print("Did not changed password")
               case .success(let res):
                   print("Name: \(res.firstName)")
                   print("Notifications: \(res.allowNotifications)")
                   print("Changed password")
            }
        }
    }
}

extension UIApplication {
    class var topViewController: UIViewController? { return getTopViewController() }
    private class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController { return getTopViewController(base: nav.visibleViewController) }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController { return getTopViewController(base: selected) }
        }
        if let presented = base?.presentedViewController { return getTopViewController(base: presented) }
        return base
    }
}

extension Hashable {
    func share() {
        let activity = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        UIApplication.topViewController?.present(activity, animated: true, completion: nil)
    }
}
