//
//  ProfileViewController.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/18/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var indexSelected: Int = 0
    var allowNotification: Bool = false
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let screenWidth = UIScreen.main.bounds.width
        scrollView.contentSize = CGSize(width: screenWidth, height: 1100)
        return scrollView
    }()
    
    lazy var settingsBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "settingsIcon"), style: .plain, target: self, action: #selector(settingsButtonPressed))
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "названиеФото"), for: .normal)
        button.addTarget(self, action: #selector(backbuttonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "ProfileIfNot")
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.contentMode = UIView.ContentMode.scaleToFill
        image.layer.cornerRadius = 10
        return image
    }()
    
    lazy var nameLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Нурайым", size: 30.0, fontType: "bold", color: .mainPurple)
        return label
    }()
    
    lazy var statisticsLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Статистика", size: 22.0, fontType: "default", color: .mainPurple)
        return label
    }()
    
    lazy var statisticsGraphView: StatisticsGraphView = {
        let view = StatisticsGraphView()
        return view
    }()
    
    lazy var pickerViewTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.text = "Жалпы"
        tf.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        tf.tintColor = .clear
        tf.font = UIFont.systemFont(ofSize: 12)
        tf.inputView = pickerView
        tf.inputAccessoryView = pickerView.toolbar
        return tf
    }()
    
    fileprivate lazy var pickerView: ToolbarPickerView = {
        let pickerView = ToolbarPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.toolbarDelegate = self
        pickerView.reloadAllComponents()
        return pickerView
    }()
    
    lazy var selectImageView: UIImageView = {
        let imageView = UIImageView()
        let image = #imageLiteral(resourceName: "downCursorIcon")
        imageView.image = image
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    lazy var analyzedInformationView: NumericInformationView = {
        let view = NumericInformationView(frame: .zero, networkManager: networkManager)
        return view
    }()
    
    lazy var historyLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Тарих", size: 22.0, fontType: "default", color: .mainPurple)
        return label
    }()
    
    lazy var calendarView: CalendarViewController = {
        let view = CalendarViewController(networkManager: self.networkManager)
        return view
    }()
    
    
    @objc
    func settingsButtonPressed() {
        let vc = SettingsViewController(networkManager: networkManager)
        vc.allowNotification = allowNotification
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
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
        title = "Профиль"
        setupViews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        
            let params = [ "type" : ["", "?period=month", "?period=year"][indexSelected] ]
            analyzedInformationView.fetchData(parameters: params)
    
        calendarView.fetchData(Date())
    }
    
    func setupViews() {
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationItem.rightBarButtonItem = settingsBarButtonItem
        pickerViewTextField.addSubview(selectImageView)
        scrollView.addSubViews(views: [settingsButton, profileImageView, nameLabel, statisticsLabel, statisticsGraphView, pickerViewTextField, analyzedInformationView, historyLabel, calendarView.view])
        view.addSubViews(views: [scrollView])
    }
    
    func setupLayout() {
        scrollView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        settingsButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstraintConstants.h5)
            make.right.equalTo(view.bounds.width - ConstraintConstants.w20)
            make.width.height.equalTo(ConstraintConstants.w20)
        }
        
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstraintConstants.h5)
            make.left.equalToSuperview().offset(ConstraintConstants.w20)
            make.width.height.equalTo(ConstraintConstants.h80)
        }

        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(ConstraintConstants.h5)
            make.left.equalTo(profileImageView.snp.right).offset(ConstraintConstants.w20)
            make.height.equalTo(ConstraintConstants.w40)
            make.width.equalToSuperview()
        }
        
        statisticsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(ConstraintConstants.h30)
            make.left.equalToSuperview().offset(ConstraintConstants.w20)
            make.height.equalTo(ConstraintConstants.w30)
            make.width.equalToSuperview()
        }
        
        statisticsGraphView.snp.makeConstraints { (make) in
            make.top.equalTo(statisticsLabel.snp.bottom).offset(ConstraintConstants.h5)
            make.left.equalTo(statisticsLabel.snp.left)
            make.right.equalTo(view.bounds.width - ConstraintConstants.w20)
            make.height.equalTo(ConstraintConstants.h130)
        }
        
        pickerViewTextField.snp.makeConstraints { (make) in
            make.top.equalTo(statisticsGraphView.snp.bottom).offset(ConstraintConstants.h17)
            make.right.equalTo(view.bounds.width - ConstraintConstants.w20)
            make.height.equalTo(ConstraintConstants.h20)
            make.width.equalTo(ConstraintConstants.w70)
        }
        
        selectImageView.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.height.width.equalTo(ConstraintConstants.w15)
            make.centerY.equalToSuperview()
        }
        
        analyzedInformationView.snp.makeConstraints { (make) in
            make.top.equalTo(pickerViewTextField.snp.bottom).offset(ConstraintConstants.h8)
            make.left.equalTo(statisticsLabel.snp.left)
            make.right.equalTo(view.bounds.width - ConstraintConstants.w20)
            make.height.equalTo(ConstraintConstants.h130)
        }

        historyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(analyzedInformationView.snp.bottom).offset(ConstraintConstants.h30)
            make.left.equalToSuperview().offset(ConstraintConstants.w20)
            make.height.equalTo(ConstraintConstants.w30)
            make.width.equalToSuperview()
        }
        
        calendarView.view.snp.makeConstraints { (make) in
            make.top.equalTo(historyLabel.snp.bottom).offset(ConstraintConstants.h15)
            make.left.equalTo(historyLabel.snp.left)
            make.right.equalTo(view.bounds.width - ConstraintConstants.w20)
            make.height.equalTo(ConstraintConstants.h540)
        }
    }
    
    
    
    private func fetchData() {
        guard let token = StorageManager.shared.token else {
            print("Error in ProfilePage, no user data (token)")
            return
        }
        
        networkManager.makeRequest(endpoint: Endpoints.getUser(token: token)) { (result: Result<ProfileData>) in
            print("Hello", result)
            switch result {
                case .failure(let errorMessage):
                    print(errorMessage)
                case .success(let res):
                    self.nameLabel.text = res.firstName
                    
                    self.allowNotification = res.allowNotifications
                    StorageManager.shared.subscribed = res.subscribed
//                    self.profileImageView.image = UIImage(named: res.avatar!) ?? #imageLiteral(resourceName: "programImage")
            }
        }
        
        networkManager.makeRequest(endpoint: Endpoints.getAkilOiOlshemi(token: token)) { (result: Result<AkilOiData>) in
                    print("Hello", result)
            switch result {
                case .failure(let errorMessage):
                    print(errorMessage)
                case .success(let res):
                    if let percent = res.percent{
                        self.statisticsGraphView.pieChartView.value = CGFloat(percent)
                    }
            }
        }
        
        networkManager.makeRequest(endpoint: Endpoints.getOneWeek(token: token)) { (result: Result<[Int]>) in
                    print("Hello", result)
            switch result {
                case .failure(let errorMessage):
                    print(errorMessage)
                case .success(let res):
                    if let timeRepo  = self.statisticsGraphView.barGraphView.presenter.runningTimeRepository{
                        print("Hello12345")
                        var massiv:[TimeGraphData] = []
                        for var item in timeRepo.timeGraphCollection!{
                            item.percentage = Double(res[item.order])
                            massiv.append(item)
                        }
                        
                        print("Hello12345\(timeRepo)")
                        self.statisticsGraphView.barGraphView.updateInfo(runningTimeCollection: massiv)
                    }
            }
        }
        
    }
}

extension ProfileViewController:  UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let pickerViewOption = StatisticsOption.init(rawValue: row)
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont(name: "Helvetica Neue", size: 16.0)
        label.text = pickerViewOption?.description
        label.textAlignment = .center
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pickerViewOption = StatisticsOption.init(rawValue: row)
        self.pickerViewTextField.text = pickerViewOption?.description
    }
}

extension ProfileViewController: ToolbarPickerViewDelegate {
    
    func didTapDone() {
        let row = pickerView.selectedRow(inComponent: 0)
        let pickerViewOption = StatisticsOption.init(rawValue: row)
        pickerView.selectRow(row, inComponent: 0, animated: false)
        pickerViewTextField.text = pickerViewOption?.description
        indexSelected = row
        let params = [ "type" : ["", "?period=month", "?period=year"][row] ]
        analyzedInformationView.fetchData(parameters: params)
        pickerViewTextField.resignFirstResponder()
    }
    
    func didTapCancel() {
        let row = pickerView.selectedRow(inComponent: 0)
        let pickerViewOption = StatisticsOption.init(rawValue: row)
        pickerViewTextField.text = pickerViewOption?.description
        pickerViewTextField.resignFirstResponder()
    }
}
