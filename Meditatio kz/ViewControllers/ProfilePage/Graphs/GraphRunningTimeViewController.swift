//
//  GraphRunningTimeViewController.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/22/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class GraphRunningTimeViewController: UIViewController {
    
    lazy var graphStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()

    lazy var indexStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var mondayLabel: UILabel = {
        let weekendLabel = UILabel()
        weekendLabel.text = "ДС"
        weekendLabel.font = UIFont.systemFont(ofSize: 10)
        weekendLabel.textAlignment = .center
        weekendLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return weekendLabel
    }()
    
    lazy var tuesdayLabel: UILabel = {
        let weekendLabel = UILabel()
        weekendLabel.text = "СС"
        weekendLabel.font = UIFont.systemFont(ofSize: 10)
        weekendLabel.textAlignment = .center
        weekendLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return weekendLabel
    }()
    
    lazy var wednesdayLabel: UILabel = {
        let weekendLabel = UILabel()
        weekendLabel.text = "СР"
        weekendLabel.font = UIFont.systemFont(ofSize: 10)
        weekendLabel.textAlignment = .center
        weekendLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return weekendLabel
    }()
    
    lazy var thursdayLabel: UILabel = {
        let weekendLabel = UILabel()
        weekendLabel.text = "БС"
        weekendLabel.font = UIFont.systemFont(ofSize: 10)
        weekendLabel.textAlignment = .center
        weekendLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return weekendLabel
    }()
    
    lazy var fridayLabel: UILabel = {
        let weekendLabel = UILabel()
        weekendLabel.text = "ЖМ"
        weekendLabel.font = UIFont.systemFont(ofSize: 10)
        weekendLabel.textAlignment = .center
        weekendLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return weekendLabel
    }()
    
    lazy var satudayLabel: UILabel = {
        let weekendLabel = UILabel()
        weekendLabel.text = "СБ"
        weekendLabel.font = UIFont.systemFont(ofSize: 10)
        weekendLabel.textAlignment = .center
        weekendLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return weekendLabel
    }()
    
    lazy var sundayLabel: UILabel = {
        let weekendLabel = UILabel()
        weekendLabel.text = "ЖС"
        weekendLabel.font = UIFont.systemFont(ofSize: 10)
        weekendLabel.textAlignment = .center
        weekendLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return weekendLabel
    }()

    let graphColor: UIColor = UIColor(red: 127/255, green: 97/255, blue: 245/255, alpha: 1.0)

    var presenter: GraphRunningTimePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = GraphRunningTimePresenter(runningTimeRepository: RunningTimeRepository.instance)
        presenter.attachView(view: self)
        presenter.viewDidLoad()
        setupViews()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    //MARK: Graph Support

    func removeGraphElements () {
//        removeIndexElements()
        removeAllGraphElements()
    }

    func newGraphElement (timeGraphData: TimeGraphData) {
//        addIndexElement(timeGraphData: timeGraphData)
        addGraphElement(timeGraphData: timeGraphData)
    }

//    private func removeIndexElements () {
//        for view in indexStackView.arrangedSubviews {
//            view.removeFromSuperview()
//        }
//    }

    private func removeAllGraphElements () {
        for view in graphStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
    }

//    private func addIndexElement (timeGraphData: TimeGraphData) {
//        let weekendLabelHeight: CGFloat = 10.0
//
//        let weekendLabel = UILabel()
//        weekendLabel.text = timeGraphData.month
//        weekendLabel.font = UIFont.systemFont(ofSize: weekendLabelHeight)
//        weekendLabel.textAlignment = .center
//        weekendLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        weekendLabel.translatesAutoresizingMaskIntoConstraints = false
//        weekendLabel.heightAnchor.constraint(equalToConstant: weekendLabelHeight).isActive = true
//        weekendLabel.layer.borderWidth = 1.0
//        weekendLabel.layer.borderColor = UIColor.yellow.cgColor
//
//        indexStackView.addArrangedSubview(weekendLabel)
//        indexStackView.translatesAutoresizingMaskIntoConstraints = false;
//    }

    private func addGraphElement (timeGraphData: TimeGraphData) {

        let amountLabelFontSize: CGFloat = 9.0 
        let amountLabelPadding: CGFloat = 15.0
        let height = heightPixelsDependOfPercentage(percentage: timeGraphData.percentage)
        let totalHeight = height + amountLabelPadding

        let verticalStackView: UIStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 4.0


        let amountLabel = UILabel()
        amountLabel.text = timeGraphData.amount
        amountLabel.font = UIFont.systemFont(ofSize: amountLabelFontSize)
        amountLabel.textAlignment = .center
        amountLabel.textColor = UIColor.darkText
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.heightAnchor.constraint(equalToConstant: amountLabelFontSize).isActive = true

        if height != 0 {
            let view = UIView()
            view.backgroundColor = graphColor
            view.layer.cornerRadius = 2
            view.clipsToBounds = true
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
            verticalStackView.addArrangedSubview(amountLabel)
            verticalStackView.addArrangedSubview(view)
        } else {
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            view.layer.cornerRadius = 2
            view.clipsToBounds = true
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
            verticalStackView.addArrangedSubview(view)
        }

        verticalStackView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false;

        graphStackView.addArrangedSubview(verticalStackView)
        graphStackView.translatesAutoresizingMaskIntoConstraints = false;
    }

    private func heightPixelsDependOfPercentage (percentage: Double) -> CGFloat {
        let maxHeight: CGFloat = 90.0
        return (CGFloat(percentage) * maxHeight) / 100
    }

    func setupViews() {
        view.layer.borderColor = UIColor.black.cgColor
        view.addSubViews(views: [graphStackView, mondayLabel, tuesdayLabel, wednesdayLabel, thursdayLabel, fridayLabel, satudayLabel, sundayLabel])
    }

    func setupLayout() {
        graphStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-ConstraintConstants.h5)
            make.height.equalTo(ConstraintConstants.h75)
            make.width.equalTo(ConstraintConstants.w150)
            make.centerX.equalToSuperview()
        }

//        indexStackView.snp.makeConstraints { (make) in
//            make.top.equalTo(graphStackView.snp.bottom).offset(-ConstraintConstants.h5)
//            make.height.equalTo(ConstraintConstants.h15)
//            make.width.equalTo(ConstraintConstants.w150)
//            make.centerX.equalToSuperview()
//        }
        mondayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(graphStackView.snp.bottom).offset(3)
            make.height.equalTo(ConstraintConstants.h15)
            make.width.equalTo(ConstraintConstants.w15)
            make.left.equalTo(graphStackView.snp.left).offset(1)
        }
        
        tuesdayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(graphStackView.snp.bottom).offset(3)
            make.height.equalTo(ConstraintConstants.h15)
            make.width.equalTo(ConstraintConstants.w15)
            make.left.equalTo(mondayLabel.snp.right).offset(7)
        }
        
        wednesdayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(graphStackView.snp.bottom).offset(3)
            make.height.equalTo(ConstraintConstants.h15)
            make.width.equalTo(ConstraintConstants.w15)
            make.left.equalTo(tuesdayLabel.snp.right).offset(7)
        }
        
        thursdayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(graphStackView.snp.bottom).offset(3)
            make.height.equalTo(ConstraintConstants.h15)
            make.width.equalTo(ConstraintConstants.w15)
            make.left.equalTo(wednesdayLabel.snp.right).offset(7)
        }
        
        fridayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(graphStackView.snp.bottom).offset(3)
            make.height.equalTo(ConstraintConstants.h15)
            make.width.equalTo(ConstraintConstants.w20)
            make.left.equalTo(thursdayLabel.snp.right).offset(5)
        }
        
        satudayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(graphStackView.snp.bottom).offset(3)
            make.height.equalTo(ConstraintConstants.h15)
            make.width.equalTo(ConstraintConstants.w15)
            make.left.equalTo(fridayLabel.snp.right).offset(5)
        }
        
        sundayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(graphStackView.snp.bottom).offset(3)
            make.height.equalTo(ConstraintConstants.h15)
            make.width.equalTo(ConstraintConstants.w18)
            make.left.equalTo(satudayLabel.snp.right).offset(5)
        }
    }
}

extension GraphRunningTimeViewController : GraphRunningTimeView {

    func updateInfo (runningTimeCollection: [TimeGraphData]){
        removeAllGraphElements()
        for timeGraphData in runningTimeCollection {
            newGraphElement(timeGraphData: timeGraphData)
        }
    }
}
