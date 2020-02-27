//
//  ForgotPasswordViewController.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 28/11/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit
import SnapKit
import SwiftValidator
import Alamofire

class ForgotPasswordViewController: UIViewController {
    
    //MARK: - UIElements
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage( #imageLiteral(resourceName: "backIcon"), for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        return button
    }()
    
    lazy var mainTitleLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Құпия сөзді ұмытып қалдыңыз ба?", size: 26.0, fontType: "bold", color: .mainPurple)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2;
        return label
    }()
    
    lazy var emailLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Пошта", size: 16.0, fontType: "default", color: .mainPurple)
        return label
    }()
    
    lazy var emailTextField: CustomSignInTextField = {
        let tf = CustomSignInTextField(padding: 40, height: 55, option: .emailTextField)
        return tf
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField])
        stackView.axis = .vertical
        stackView.spacing = 0.5
        stackView.distribution = .fillEqually
        stackView.layer.borderColor =  #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        stackView.layer.borderWidth = 1.0
        return stackView
    }()
    
    lazy var signUpLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Жіберу", size: 26.0, fontType: "bold", color: .mainPurple)
        return label
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setImage( #imageLiteral(resourceName: "nextIcon"), for: .normal)
        button.layer.cornerRadius = ConstraintConstants.w60/2
        button.layer.backgroundColor =  #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
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
        view.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
    
    @objc func signUpButtonPressed() {
        validator.validate(self)
    }
    
    @objc func signInButtonPressed() {
        
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Setup methods

private extension ForgotPasswordViewController {
    
    func setupViews() {
        view.addSubViews(views: [backButton, mainTitleLabel, stackView, signUpLabel, signUpButton])
    }
    
    func setupLayout() {
        
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
            make.width.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(ConstraintConstants.h15)
            make.left.equalTo(mainTitleLabel.snp.left)
            make.right.equalToSuperview().offset(-ConstraintConstants.w30)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        signUpLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-ConstraintConstants.h100)
            make.left.equalTo(stackView.snp.left)
            make.width.equalTo(ConstraintConstants.w130)
            make.height.equalTo(ConstraintConstants.h30)
        }
        
        signUpButton.snp.makeConstraints { (make) in
            make.right.equalTo(stackView.snp.right)
            make.width.equalTo(ConstraintConstants.w60)
            make.height.equalTo(ConstraintConstants.w60)
            make.centerY.equalTo(signUpLabel)
        }
    }
    
    //MARK: - Setup Validator methods
    
    func setupValidator() {
        
        func setupValidator() {
            validator.registerField(emailTextField, rules: [RequiredRule(), EmailRule()])
            validator.styleTransformers(success:{ (validationRule) in
                print("Successfully registered")
                if let textfield = validationRule.field as? UITextField {
                    textfield.layer.borderWidth = 0.5
                    textfield.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
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

extension ForgotPasswordViewController: ValidationDelegate {
    
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
