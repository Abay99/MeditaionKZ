//
//  EditProfileViewController.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/15/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit
import SwiftValidator
import Alamofire

class EditProfileViewController: UIViewController {
    
    //MARK: - UIElements
    
    let validator = Validator()
    
    private var imgProfile: UIImage?
    
    lazy var pickProfileImageButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ProfileIfNot"), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.3411764706, blue: 0.5254901961, alpha: 1)
        button.layer.cornerRadius = 20
        button.contentMode = UIView.ContentMode.scaleToFill
        button.addTarget(self, action: #selector(pickerImagePressed), for: .touchUpInside)
        return button
    }()
    
    lazy var imagePicker: ImagePicker = {
        let rootController = UIApplication.shared.keyWindow!.rootViewController!
        let imagePicker = ImagePicker(presentationController: rootController, delegate: self)
        return imagePicker
    }()
    
    @objc func pickerImagePressed() {
           self.imagePicker.present(from: self.view)
           print("dal")
       }
    
    lazy var nameLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Аты", size: 16.0, fontType: "default", color: .mainPurple)
        return label
    }()
    
    lazy var nameTextField: CustomSignInTextField = {
        let tf = CustomSignInTextField(padding: 40, height: 55, option: .nameTextField)
        return tf
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
        let stackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField, emailLabel, emailTextField])
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        stackView.layer.borderWidth = 1.0
        return stackView
    }()
    
    lazy var updateProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Профильді жаңарту", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        button.titleLabel?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.addTarget(self, action: #selector(updateProfilePressed), for: .touchUpInside)
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
    
    @objc func updateProfilePressed() {
        validator.validate(self)
    }
}
    
//MARK: - Setup methods
    
private extension EditProfileViewController {
    func setupNavigationBar() {
        navigationItem.title = "Профильді өзгерту"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor : UIColor.mainBlue
        ]
        
        navigationController?.navigationBar.tintColor = .mainBlue
        
        
    }
    
    func setupViews() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubViews(views: [pickProfileImageButton, stackView, updateProfileButton])
    }
    
    func setupLayout() {
        pickProfileImageButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstraintConstants.h90)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(ConstraintConstants.w120)
        }
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(pickProfileImageButton.snp.bottom).offset(ConstraintConstants.h30)
            make.left.equalTo(ConstraintConstants.w13)
            make.right.equalToSuperview().offset(-ConstraintConstants.w13)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        updateProfileButton.snp.makeConstraints { (make) in
            make.height.equalTo(ConstraintConstants.h40)
            make.left.equalTo(stackView)
            make.right.equalTo(stackView)
            make.bottom.equalToSuperview().offset(-ConstraintConstants.h25)
        }
    }
    
    func setupValidator() {
        validator.registerField(nameTextField, rules: [RequiredRule(), MinLengthRule(length: 6), MaxLengthRule(length: 30)])
        validator.registerField(emailTextField, rules: [RequiredRule(), EmailRule()])
        validator.styleTransformers(success: { (validationRule) in
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderWidth = 0.5
                textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }, error: { (validationError) in
            if let textField = validationError.field as? UITextField {
                textField.layer.borderWidth = 1.0
                textField.layer.borderColor = UIColor.red.cgColor
            }
        })
    }
}

extension EditProfileViewController: ValidationDelegate {
    func validationSuccessful() {
        print("Validation Succeeded")
        guard let token = StorageManager.shared.token, let image = imgProfile else {
                   print("Error in ProfilePage, no user data (token)")
                   return
               }
        
        let params = ["first_name": nameTextField.text!] as Parameters
        
        networkManager.makeRequest(endpoint: Endpoints.editProfile(token: token, data: image.pngData()!, parameters: params)) { (result: Result<ProfileData>) in
            print("Hello", result)
            switch result {
            case .failure(let errorMessage):
                print(errorMessage)
            case .success(let res):
                print("FirstName")
                if let name = res.firstName {
                    
                    print("FirstName \(name)")
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        print("Validation Failed")
    }
}

extension EditProfileViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.pickProfileImageButton.setImage(image, for: .normal)
        imgProfile = image
    }
}
