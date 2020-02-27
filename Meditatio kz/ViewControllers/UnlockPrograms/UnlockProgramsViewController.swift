
//
//  UnlockProgramsViewController.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 11/20/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit
import TYCyclePagerView

class UnlockProgramsViewController: UIViewController {
    
    private var programAdvantages: [String] = [
        "Барлық материалдарға шектеусіз қол жеткізе отырып, тынығып, ұйықтаңыз.",
        "Бағдарламалардың көмегімен стресс пен мазасыздықты азайтыңыз.",
        "Күн сайын жаңа тақырыптар.",
        "Офлайн режимінде кез келген жерде қол жеткізе аласыз."
    ]
    
    private enum LocalConstants {
        static let cellIdentifier: String = "UnlockProgramCell"
        static let cellHeight: CGFloat = ConstraintConstants.h50
    }
    
    private var paymentTypes: [Payment] = []
    var onePressId: Int?
    
    //MARK: - UIElements
    
    lazy var backgroundView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "Background")
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = #imageLiteral(resourceName: "cancelButton")
        button.style = .plain
        button.target = self
        button.action = #selector(cancelButtonPressed)
        return button
    }()
    
    lazy var mainTitleLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Тегін қолданып көр!", size: 30.0, fontType: "bold", color: .white)
        return label
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["1 ай", "12 ай", "6 ай"])
        segmentedControl.layer.cornerRadius = 10
        segmentedControl.layer.masksToBounds = true
        segmentedControl.tintColor = .mainBlue
        let font = UIFont.systemFont(ofSize: 32)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segmentedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    @objc func indexChanged(_ sender: UISegmentedControl){
        if paymentTypes.count > 0{
            onePressId = paymentTypes[sender.selectedSegmentIndex].id
            updatePasswordButton.isUserInteractionEnabled = true
        }
       
    }

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews(programTitles: self.programAdvantages))
        stackView.axis = .vertical
        stackView.spacing = 0.5
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "7 күн бойы тегін пайдаланып көріңіз, содан кейін бағасы айына 1,607.50 теңге болады. Төлем жылына бір рет. Кез келген уақытта бас тартуға болады."
        label.textAlignment = .center
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    lazy var updatePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Жалғастыру", for: .normal)
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.mainPurple, for: .normal)
        button.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        button.contentHorizontalAlignment = .center
        button.clipsToBounds = true
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    @objc func nextPressed() {
        if let onePressId = onePressId{
            
            guard let token = StorageManager.shared.token else {
                print("Error in ProfilePage, no user data (token)")
                return
            }
            
            let params = ["subscription_type_id": onePressId]
            
            networkManager.makeRequest(endpoint: Endpoints.postPayboxPay(token: token, params: params)) { (result: Result<UrlPayment>) in
                print("Hello", result)
                switch result {
                    case .failure(let errorMessage):
                        print(errorMessage)
                    case .success(let result):
                        if let res = result.redirect_url{
                            if let url = URL(string: res) {
                                
                                UIApplication.shared.open(url)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                    self.dismiss(animated: true, completion: nil)
                                })
//                                self.cancelButtonPressed()
                            }
                        }

                }
            }
        }
    }
    
    lazy var oneMonthPaymentView: MonthPaymentView = {
        let view = MonthPaymentView(frame: .zero, quantityOfMonth: "", paymentForOneMonth: "KZT 1,490.00/ай.")
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    lazy var sixMonthPaymentView: MonthPaymentView = {
        let view = MonthPaymentView(frame: .zero, quantityOfMonth: "", paymentForOneMonth: "KZT 2,248.33/ай.")
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    lazy var twelveMonthPaymentView: MonthPaymentView = {
        let view = MonthPaymentView(frame: .zero, quantityOfMonth: "", paymentForOneMonth: "Тегін пайдаланып көр.")
        return view
    }()
    
    lazy var programAdvantage: ProgramAdvantage = {
        let view = ProgramAdvantage(frame: .zero, title: "Тегін пайдаланып көр.")
        return view
    }()
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle, Initilizers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        print(12345678)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    
    @objc func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func arrangedSubviews(programTitles: [String]) -> [UIView] {
        var views: [UIView] = []
        for title in programTitles {
            views.append(ProgramAdvantage(frame: .zero, title: title))
        }
        return views
    }
}

//MARK: - Setup methods
    
private extension UnlockProgramsViewController {
    
    func setupViews() {
        navigationItem.rightBarButtonItem = cancelButton
        view.addSubview(backgroundView)
        backgroundView.addSubViews(views: [mainTitleLabel, stackView, updatePasswordButton, descriptionLabel, oneMonthPaymentView, sixMonthPaymentView, twelveMonthPaymentView, segmentedControl])
        
    }
    
    func setupLayouts() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(ConstraintConstants.h70)
            $0.left.equalTo(ConstraintConstants.w13)
            $0.right.equalTo(-ConstraintConstants.w13)
            $0.height.equalTo(ConstraintConstants.h30)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(ConstraintConstants.h20)
            $0.width.equalToSuperview()
            $0.height.equalTo(ConstraintConstants.h200)
        }
        
        updatePasswordButton.snp.makeConstraints {
            $0.bottom.equalTo(-ConstraintConstants.h20)
            $0.left.equalTo(ConstraintConstants.w13)
            $0.right.equalTo(-ConstraintConstants.w13)
            $0.height.equalTo(ConstraintConstants.h50)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(updatePasswordButton.snp.top).offset(-ConstraintConstants.h5)
            $0.left.equalTo(ConstraintConstants.w30)
            $0.right.equalTo(-ConstraintConstants.w30)
            $0.height.equalTo(ConstraintConstants.h30)
        }
        
        twelveMonthPaymentView.snp.makeConstraints {
            $0.bottom.equalTo(descriptionLabel.snp.top).offset(-ConstraintConstants.h40)
            $0.width.equalTo(ConstraintConstants.w110)
            $0.height.equalTo(ConstraintConstants.h110)
            $0.centerX.equalToSuperview()
        }
        
        oneMonthPaymentView.snp.makeConstraints {
            $0.bottom.equalTo(descriptionLabel.snp.top).offset(-ConstraintConstants.h40)
            $0.right.equalTo(twelveMonthPaymentView.snp.left).offset(-1)
            $0.width.height.equalTo(twelveMonthPaymentView)
        }
        
        sixMonthPaymentView.snp.makeConstraints {
            $0.bottom.equalTo(descriptionLabel.snp.top).offset(-ConstraintConstants.h40)
            $0.left.equalTo(twelveMonthPaymentView.snp.right).offset(1)
            $0.width.height.equalTo(twelveMonthPaymentView)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.centerY.equalTo(twelveMonthPaymentView.snp.centerY)
            $0.left.equalTo(oneMonthPaymentView.snp.left)
            $0.right.equalTo(sixMonthPaymentView.snp.right)
            $0.height.equalTo(ConstraintConstants.h110)
        }
    }
}


// data - Fetching
extension UnlockProgramsViewController{
    private func fetchData() {
        guard let token = StorageManager.shared.token else {
            print("Error in ProfilePage, no user data (token)")
            return
        }
        
        networkManager.makeRequest(endpoint: Endpoints.getPaymentType(token: token)) { (result: Result<PaymentType>) in
            print("Hello", result)
            switch result {
                case .failure(let errorMessage):
                    print(errorMessage)
                case .success(let result):
                    if let res = result.results{
                        self.paymentTypes = res
                    }

            }
        }
    }
}
