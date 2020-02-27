//
//  SignInViewController.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/9/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Alamofire
import SwiftValidator

class SignInViewController: UIViewController {
    
    let validator = Validator()
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        return view
    }()
    
    lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "white_logo")
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    lazy var mainTitleLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Қош келдіңіз", size: 32.0, fontType: "bold", color: .mainBlue)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0;
        return label
    }()
    
    lazy var emailLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Пошта", size: 16.0, fontType: "default", color: .mainBlue)
        return label
    }()

    lazy var emailTextField: CustomSignInTextField = {
        let tf = CustomSignInTextField(padding: 40, height: 55, option: .emailTextField)
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    lazy var passwordLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Пароль", size: 16.0, fontType: "default", color: .mainBlue)
        return label
    }()
    
    lazy var passwordTextField: CustomSignInTextField = {
        let tf = CustomSignInTextField(padding: 40, height: 55, option: .passwordTextField)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let signInViewModel = SigninViewModel()
    
    @objc
    fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            signInViewModel.email = textField.text!
        } else {
            signInViewModel.password = textField.text!
        }
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField, passwordLabel, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 0.5
        stackView.distribution = .fillEqually
        stackView.layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        stackView.layer.borderWidth = 1.0
        return stackView
    }()
    
    lazy var signInLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Кіру", size: 26.0, fontType: "bold", color: .mainBlue)
        return label
    }()
    
    lazy var signUpButton: UIButton = {
        let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedText = NSAttributedString(string: "Тіркелу", attributes: attributes)
        let button = UIButton()
        button.setTitleColor(.mainBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.titleLabel?.attributedText = attributedText
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
//        button.titleLabel?.textColor = .mainBlue
        button.setTitle("Тіркелу", for: .normal)
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var changePasswordButton: UIButton = {
        let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedText = NSAttributedString(string: "Құпия сөзді ұмытып қалдыңыз", attributes: attributes)
        let button = UIButton()
        button.setTitleColor(.mainBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.titleLabel?.attributedText = attributedText
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        button.setTitle("Құпия сөзді ұмытып қалдыңыз", for: .normal)
        button.addTarget(self, action: #selector(changePasswordButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "nextIcon"), for: .normal)
        button.layer.cornerRadius = ConstraintConstants.w60/2
        button.layer.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func signUpButtonPressed() {
        let vc = SignUpViewController(networkManager: networkManager)
        present(vc, animated: true, completion: nil)
    }
    
    
    @objc func signInButtonPressed() {
        validator.validate(self)
        
    }
    
    @objc func changePasswordButtonPressed() {
        let vc = ForgotPasswordViewController(networkManager: networkManager)
        present(vc, animated: true, completion: nil)
    }
    
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
    
    func setupViews() {
        headerView.addSubview(logoImageView)
        mainView.addSubViews(views: [mainTitleLabel, stackView, signInLabel, signInButton, signUpButton, changePasswordButton])
        view.addSubViews(views: [headerView, mainView])
    }
    
    func setupLayout() {
        headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(ConstraintConstants.h150)
        }
        
        logoImageView.snp.makeConstraints { (make) in
            make.width.equalTo(ConstraintConstants.w60)
            make.height.equalTo(ConstraintConstants.w60)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(ConstraintConstants.w60)
        }

        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(-ConstraintConstants.h10)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        mainTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstraintConstants.h30)
            make.left.equalToSuperview().offset(ConstraintConstants.w30)
            make.height.equalTo(ConstraintConstants.h100)
            make.width.equalTo(ConstraintConstants.w130)
        }
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(ConstraintConstants.h20)
            make.left.equalTo(mainTitleLabel.snp.left)
            make.right.equalToSuperview().offset(-ConstraintConstants.w30)
            make.height.equalToSuperview().multipliedBy(0.2)
        }

        signInLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(signInButton)
            make.left.equalTo(stackView.snp.left)
            make.width.equalTo(ConstraintConstants.w60)
            make.height.equalTo(ConstraintConstants.h30)
        }

        signInButton.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(ConstraintConstants.h90)
            make.right.equalTo(stackView.snp.right)
            make.width.equalTo(ConstraintConstants.w60)
            make.height.equalTo(ConstraintConstants.w60)
        }

        signUpButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-ConstraintConstants.h150)
            make.left.equalTo(stackView.snp.left)
            make.width.equalTo(ConstraintConstants.w60)
            make.height.equalTo(ConstraintConstants.h25)
        }
        
        changePasswordButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-ConstraintConstants.h150)
            make.right.equalTo(stackView.snp.right)
            make.width.equalTo(ConstraintConstants.w220)
            make.height.equalTo(ConstraintConstants.h25)
        }
    }
    
    func setupValidator() {
        validator.registerField(emailTextField, rules: [EmailRule(), MinLengthRule(length: 5), MaxLengthRule(length: 40)])
        validator.registerField(passwordTextField, rules: [RequiredRule(), MinLengthRule(length: 5), MaxLengthRule(length: 40)])
        
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

extension SignInViewController: ValidationDelegate {
    func validationSuccessful() {
        print("Validation Succeeded")
        if signInViewModel.checkFormValidity(){
            if let email = signInViewModel.email, let password = signInViewModel.password{
                let params = ["email": email.lowercased(), "password": password] as Parameters
                networkManager.makeRequest(endpoint: Endpoints.login(parameters: params )) { (result: Result<GetToken>) in
                    switch result {
                    case .failure(let errorMessage):
                        print(errorMessage)
                        self.emailTextField.layer.borderWidth = 1.0
                        self.emailTextField.layer.borderColor = UIColor.red.cgColor
                        
                        self.passwordTextField.layer.borderWidth = 1.0
                        self.passwordTextField.layer.borderColor = UIColor.red.cgColor
                    case .success(let res):
                        if res.token != nil{
                            print(res.token)
                            StorageManager.shared.email = email.lowercased()
                                StorageManager.shared.token = res.token
                            self.appDelegate.navigateToTabBarViewController()
                        }else{
                            self.emailTextField.layer.borderWidth = 1.0
                            self.emailTextField.layer.borderColor = UIColor.red.cgColor
                            
                            self.passwordTextField.layer.borderWidth = 1.0
                            self.passwordTextField.layer.borderColor = UIColor.red.cgColor
                        }
                        
                    }
                }
            }
            
            
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        print("Validation Failed")
    }
}
