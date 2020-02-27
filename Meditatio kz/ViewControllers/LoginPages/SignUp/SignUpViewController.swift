//
//  SignUpViewController.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/11/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SwiftValidator
import Alamofire

class SignUpViewController: UIViewController {
    
    //MARK: - UIElements
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "backIcon"), for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        return button
    }()
    
    
    lazy var mainTitleLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Аккаунт құру", size: 32.0, fontType: "bold", color: .mainBlue)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0;
        return label
    }()
    
    lazy var nameLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Аты", size: 16.0, fontType: "default", color: .mainBlue)
        return label
    }()
    
    lazy var nameTextField: CustomSignInTextField = {
        let tf = CustomSignInTextField(padding: 40, height: 55, option: .nameTextField)
        return tf
    }()
    
    lazy var emailLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Пошта", size: 16.0, fontType: "default", color: .mainBlue)
        return label
    }()
    
    lazy var emailTextField: CustomSignInTextField = {
        let tf = CustomSignInTextField(padding: 40, height: 55, option: .emailTextField)
        return tf
    }()
    
    lazy var passwordLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Құпия сөз", size: 16.0, fontType: "default", color: .mainBlue)
        return label
    }()
    
    lazy var passwordTextField: CustomSignInTextField = {
        let tf = CustomSignInTextField(padding: 40, height: 55, option: .passwordTextField)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField, emailLabel, emailTextField, passwordLabel, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 0.5
        stackView.distribution = .fillEqually
        stackView.layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        stackView.layer.borderWidth = 1.0
        return stackView
    }()
    
    lazy var signUpLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Тіркелу", size: 26.0, fontType: "bold", color: .mainBlue)
        return label
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "nextIcon"), for: .normal)
        button.layer.cornerRadius = ConstraintConstants.w60/2
        button.layer.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    @objc func signUpButtonPressed() {
        validator.validate(self)
    }
    
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    //MARK: - Initializers
    
    let validator = Validator()
    
    var signUpViewModel = SignUpViewModel()
    
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
        // Do any additional setup after loading the view.
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupViews()
        setupLayout()
        setupValidator()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // needed to clear the text in the back navigation:
        self.navigationItem.title = " "
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

//MARK: - Setup methods

extension SignUpViewController {
    
    private func setupViews() -> Void {
        view.addSubViews(views: [backButton, mainTitleLabel, stackView, signUpLabel, signUpButton])
    }
    
    private func setupLayout() -> Void {
        
        backButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstraintConstants.h50)
            make.left.equalToSuperview().offset(ConstraintConstants.w30)
            make.width.equalTo(ConstraintConstants.w30)
            make.height.equalTo(ConstraintConstants.w30)
        }
        
        mainTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backButton.snp.bottom).offset(ConstraintConstants.h25)
            make.left.equalToSuperview().offset(ConstraintConstants.w30)
            make.height.equalTo(ConstraintConstants.h100)
            make.width.equalTo(ConstraintConstants.w130)
        }

        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(ConstraintConstants.h15)
            make.left.equalTo(mainTitleLabel.snp.left)
            make.right.equalToSuperview().offset(-ConstraintConstants.w30)
            make.height.equalToSuperview().multipliedBy(0.3)
        }

        signUpLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(signUpButton)
            make.left.equalTo(stackView.snp.left)
            make.width.equalTo(ConstraintConstants.w130)
            make.height.equalTo(ConstraintConstants.h30)
        }

        signUpButton.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(ConstraintConstants.h70)
            make.right.equalTo(stackView.snp.right)
            make.width.equalTo(ConstraintConstants.w60)
            make.height.equalTo(ConstraintConstants.w60)
        }
    }
    
    //MARK: - Setup Validator methods
    
    private func setupValidator() -> Void {
        
        func setupValidator() {
            validator.registerField(nameTextField, rules: [RequiredRule(), MinLengthRule(length: 6), MaxLengthRule(length: 30)])
            validator.registerField(emailTextField, rules: [RequiredRule(), EmailRule()])
            validator.registerField(passwordTextField, rules: [RequiredRule(), MinLengthRule(length: 6), MaxLengthRule(length: 30)])
            validator.styleTransformers(success:{ (validationRule) in
                print("Successfully registered")
                if let textfield = validationRule.field as? UITextField {
                    textfield.layer.borderWidth = 0.5
                    textfield.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
                
            }, error: { (validationError) in
                print("Error happened in registration of user")
                if let textfield = validationError.field as? UITextField {
                    textfield.layer.borderWidth = 1.0
                    textfield.layer.borderColor = UIColor.red.cgColor
                }
            })
        }
    }
}

//MARK: - ValidationDelegate

extension SignUpViewController: ValidationDelegate {
    
    func validationSuccessful() {
        if signUpViewModel.checkFormValidity() {
            let parameters = ["email": signUpViewModel.email!, "first_name": signUpViewModel.name!, "password": signUpViewModel.password!] as Parameters
            networkManager.makeRequest(endpoint: Endpoints.registration(parameters: parameters)) { (result: Result<RegistrationData>) in
                switch result {
                    case .failure(let errorMessage):
                            print(errorMessage)
                    case .success(let res):
                        print(res.email)
                        print(res.firstName)
                        self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        print("Validation Failed!")
    }
}
