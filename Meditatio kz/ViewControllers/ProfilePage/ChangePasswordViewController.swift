//
//  ChangePasswordViewController.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 11/7/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit
import SwiftValidator
import Alamofire

class ChangePasswordViewController: UIViewController {
    
    //MARK: -UIElements
    
    let validator = Validator()
    
    lazy var oldPasswordLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Ескі құпия сөз", size: 16.0, fontType: "default", color: .mainPurple)
        return label
    }()
    
    lazy var oldPasswordTextField: CustomSignInTextField = {
        let tf = CustomSignInTextField(padding: 40, height: 55, option: .passwordTextField)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var newPasswordLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Жаңа құпия сөз", size: 16.0, fontType: "default", color: .mainPurple)
        return label
    }()
    
    lazy var newPasswordTextField: CustomSignInTextField = {
        let tf = CustomSignInTextField(padding: 40, height: 55, option: .passwordTextField)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var repeatedPasswordLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Жаңа құпия сөз қайталау", size: 16.0, fontType: "default", color: .mainPurple)
        return label
    }()
    
    lazy var repeatedPasswordTextField: CustomSignInTextField = {
        let tf = CustomSignInTextField(padding: 40, height: 55, option: .passwordTextField)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [oldPasswordLabel, oldPasswordTextField, newPasswordLabel, newPasswordTextField, repeatedPasswordLabel, repeatedPasswordTextField])
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        stackView.layer.borderWidth = 1.0
        return stackView
    }()
    
    lazy var updatePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Құпия сөзді жаңарту", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.titleLabel?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.addTarget(self, action: #selector(updatePasswordPressed), for: .touchUpInside)
        button.contentHorizontalAlignment = .center
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
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
        setupNavigationBar()
        setupViews()
        setupLayout()
        setupValidator()
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func updatePasswordPressed() {
        validator.validate(self)
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Құпия сөзді өзгерту"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor : UIColor.mainBlue
        ]
        navigationController?.navigationBar.tintColor = .mainBlue
    }
    
    func setupViews() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubViews(views: [stackView, updatePasswordButton])
    }
    
    func setupLayout() {
        stackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstraintConstants.h150)
            make.left.equalTo(ConstraintConstants.w13)
            make.right.equalTo(-ConstraintConstants.w13)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        updatePasswordButton.snp.makeConstraints { (make) in
            make.height.equalTo(ConstraintConstants.h40)
            make.left.equalTo(stackView)
            make.right.equalTo(stackView)
            make.bottom.equalToSuperview().offset(-ConstraintConstants.h25)
        }
    }
    
    func setupValidator() {
        validator.registerField(oldPasswordTextField, rules: [RequiredRule(), MinLengthRule(length: 5), MaxLengthRule(length: 30)])
        validator.registerField(newPasswordTextField, rules: [RequiredRule(), MinLengthRule(length: 6), MaxLengthRule(length: 30)])
        validator.registerField(repeatedPasswordTextField, rules: [RequiredRule(), MinLengthRule(length: 6), MaxLengthRule(length: 30), ConfirmationRule(confirmField: newPasswordTextField)])
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("Successfully changed password in Profile")
            if let textfield = validationRule.field as? UITextField {
                textfield.layer.borderWidth = 0.5
                textfield.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
            
        }, error: { (validationError) -> Void in
            print("Error happened in changing password in Profile")
            if let textfield = validationError.field as? UITextField {
                textfield.layer.borderWidth = 1.0
                textfield.layer.borderColor = UIColor.red.cgColor
            }
        })
    }
}

extension ChangePasswordViewController: ValidationDelegate {
    func validationSuccessful() {
        
        if let oldPass =  oldPasswordTextField.text, let newPass = newPasswordTextField.text{
            let parameters = ["old_password": oldPass, "password": newPass] as Parameters
            
            guard let token = StorageManager.shared.token else {
                print("Error in ProfilePage, no user data (token)")
                return
            }
            
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
                    
                    if let email = StorageManager.shared.email{
                        let params = ["email": email, "password": newPass] as Parameters
                        
                        self.networkManager.makeRequest(endpoint: Endpoints.login(parameters: params)) { (result: Result<GetToken>) in
                            switch result {
                            case .failure(let errorMessage):
                                print(errorMessage)
                                print("Did not changed password")
                            case .success(let res):
                                StorageManager.shared.token = res.token
                                self.navigationController?.popViewController(animated: true)
                            }

                        }
                        
                        
                    }
                }
            }
        }
        
        
        
       
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        func validationFailed(_ errors: [(Validatable, ValidationError)]) {
            print("Validation FAILED")
        }
    }
    
    @objc func leftPressed(){
        if let presentedVC = presentedViewController {
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            presentedVC.view.window!.layer.add(transition, forKey: kCATransition)
        }
        
        dismiss(animated: false, completion: nil)
    }
}
