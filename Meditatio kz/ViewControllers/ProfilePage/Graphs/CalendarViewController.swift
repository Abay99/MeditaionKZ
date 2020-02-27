//
//  ProfileCalendarView.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/23/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    
    var sessions: [Track] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "kk")
        formatter.dateFormat = "MMMM, d"
        return formatter
    }()
    
    fileprivate lazy var requestDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "kk")
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.firstWeekday = 2
        calendar.appearance.headerTitleColor = .mainPurple
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20.0)
        calendar.appearance.titleDefaultColor = .mainPurple
        calendar.appearance.titleSelectionColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        calendar.appearance.todayColor = .mainPurple
        calendar.appearance.weekdayTextColor = .mainPurple
        calendar.appearance.selectionColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        calendar.appearance.titleSelectionColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        var locale = NSLocale(localeIdentifier: "kk")
        calendar.locale = locale as Locale
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        return calendar
    }()
    
    lazy var selectedDateLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "Cәрсенбі, 23", size: 16.0, fontType: "default", color: .mainPurple)
        label.textAlignment = .left
        return label
    }()
    
    lazy var sessionNumberLabel: CustomSignInLabel = {
        let label = CustomSignInLabel(title: "2 сеанс", size: 16.0, fontType: "default", color: .mainPurple)
        label.textAlignment = .right
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SessionCell.self, forCellReuseIdentifier: SessionCell.name)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = true
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.separatorStyle = .none
        return tableView
    }()
    
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
        setupInitialViews()
        setupViews()
        setupLayout()
        setupBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupInitialViews() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 4.0
        view.layer.masksToBounds = false
    }
    
    func setupViews() {
        view.addSubViews(views: [calendar, selectedDateLabel, sessionNumberLabel, tableView])
    }
    
    func setupLayout() {
        calendar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(ConstraintConstants.h220)
        }
        
        selectedDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(calendar.snp.bottom)
            make.left.equalToSuperview().offset(ConstraintConstants.w13)
            make.width.equalToSuperview()
            make.height.equalTo(ConstraintConstants.h20)
        }
        
        sessionNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(calendar.snp.bottom)
            make.right.equalToSuperview().offset(-ConstraintConstants.w13)
            make.width.equalToSuperview()
            make.height.equalTo(ConstraintConstants.h20)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(selectedDateLabel.snp.bottom).offset(ConstraintConstants.h5)
            make.left.equalToSuperview().offset(ConstraintConstants.w13)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-ConstraintConstants.w13)
        }
    }

    private func setupBackground(){
        let noDataLabel = UILabel()
        noDataLabel.textAlignment = .center
        noDataLabel.textColor = .mainPurple
        noDataLabel.text = "Нәтиже жоқ"
        noDataLabel.center = view.center
        tableView.backgroundView = noDataLabel
        tableView.backgroundView?.isHidden = true
        
    }
}

extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        fetchData(date)
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
}
// Data - Fetching
extension CalendarViewController{
    func fetchData(_ date: Date){
        let textDate = self.dateFormatter.string(from: date)
        selectedDateLabel.text = textDate
        print("did select date \(textDate)")
        let startDate = self.requestDateFormatter.string(from: date)
        print("did select date \(startDate)")
        let nextDate = date.addingTimeInterval(1440 * 60)
        let endDate = self.requestDateFormatter.string(from: nextDate)
        print("did select date \(endDate)")
        
        guard let token = StorageManager.shared.token else {
            print("Error in ProfilePage, no user data (token)")
            return
        }
        
        let parameters = ["start_date": startDate, "end_date": endDate] as [String : Any]
        
        networkManager.makeRequest(endpoint: Endpoints.postShowTrack(token: token, parameters: parameters)) { (result: Result<[Track]>) in
            switch result {
            case .failure(let errorMessage):
                print(errorMessage)
            case .success(let results):
                self.sessions = results
            }
        }
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConstraintConstants.h70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sessions.isEmpty{
            tableView.backgroundView?.isHidden = false
        }else{
            tableView.backgroundView?.isHidden = true
        }
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SessionCell.name) as! SessionCell
        cell.data = self.sessions[indexPath.row ]
        return cell
    }
    
}
