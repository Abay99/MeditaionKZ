//
//  GraphRunnningView.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 10/22/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

//import Foundation
//import UIKit
//import SnapKit
//
//class BarGraphView: UIView {
//
////    lazy var graphView: UIView = {
////        let view = UIView()
////        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
////        view.clipsToBounds = true
////        view.layer.cornerRadius = 10
////        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
////        view.layer.shadowOffset = CGSize(width: 3, height: 3)
////        view.layer.shadowOpacity = 1.0
////        view.layer.shadowRadius = 4.0
////        view.layer.masksToBounds = false
////        return view
////    }()
//
//    lazy var graphStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.alignment = .bottom
//        stackView.distribution = .fillEqually
//        stackView.spacing = 20
//        return stackView
//    }()
//
//    lazy var indexStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.alignment = .bottom
//        stackView.distribution = .fillEqually
//        stackView.spacing = 20
//        return stackView
//    }()
//
//    let graphColor: UIColor = UIColor(red: 127/255, green: 97/255, blue: 245/255, alpha: 1.0)
//
//    var presenter: GraphRunningTimePresenter!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.presenter = GraphRunningTimePresenter(runningTimeRepository: RunningTimeRepository.instance)
//        presenter.attachView(view: self)
//        presenter.viewDidLoad()
//        setupViews()
//        setupLayout()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        self.presenter = GraphRunningTimePresenter(runningTimeRepository: RunningTimeRepository.instance)
////        presenter.attachView(view: self)
////        presenter.viewDidLoad()
////        setupViews()
////        setupLayout()
////    }
////
////    override func viewWillAppear(_ animated: Bool) {
////        super.viewWillAppear(animated)
////        presenter.viewWillAppear()
////    }
//
//    //MARK: Graph Support
//
//    func removeGraphElements () {
//        removeIndexElements()
//        removeAllGraphElements()
//    }
//
//    func newGraphElement (timeGraphData: TimeGraphData) {
//        addIndexElement(timeGraphData: timeGraphData)
//        addGraphElement(timeGraphData: timeGraphData)
//    }
//
//    private func removeIndexElements () {
//        for view in indexStackView.arrangedSubviews {
//            view.removeFromSuperview()
//        }
//    }
//
//    private func removeAllGraphElements () {
//        for view in graphStackView.arrangedSubviews {
//            view.removeFromSuperview()
//        }
//    }
//
//    private func addIndexElement (timeGraphData: TimeGraphData) {
//        let weekendLabelHeight: CGFloat = 13.0
//
//        let weekendLabel = UILabel()
//        weekendLabel.text = timeGraphData.month
//        weekendLabel.font = UIFont.systemFont(ofSize: weekendLabelHeight)
//        weekendLabel.textAlignment = .center
//
//        weekendLabel.heightAnchor.constraint(equalToConstant: weekendLabelHeight).isActive = true
//
//        indexStackView.addArrangedSubview(weekendLabel)
//        indexStackView.translatesAutoresizingMaskIntoConstraints = false;
//    }
//
//    private func addGraphElement (timeGraphData: TimeGraphData) {
//
//        let amountLabelFontSize: CGFloat = 9.0
//        let amountLabelPadding: CGFloat = 15.0
//        let height = heightPixelsDependOfPercentage(percentage: timeGraphData.percentage)
//        let totalHeight = height + amountLabelPadding
//
//        let verticalStackView: UIStackView = UIStackView()
//        verticalStackView.axis = .vertical
//        verticalStackView.alignment = .fill
//        verticalStackView.distribution = .fill
//        verticalStackView.spacing = 8.0
//
//
//
//        let amountLabel = UILabel()
//        amountLabel.text = timeGraphData.amount
//        amountLabel.font = UIFont.systemFont(ofSize: amountLabelFontSize)
//        amountLabel.textAlignment = .center
//        amountLabel.textColor = UIColor.darkText
//        amountLabel.adjustsFontSizeToFitWidth = true
//        amountLabel.heightAnchor.constraint(equalToConstant: amountLabelFontSize).isActive = true
//
//        if height != 0 {
//            let view = UIView()
//            view.backgroundColor = graphColor
//            view.layer.cornerRadius = 5
//            view.clipsToBounds = true
//            view.heightAnchor.constraint(equalToConstant: height).isActive = true
//            verticalStackView.addArrangedSubview(amountLabel)
//            verticalStackView.addArrangedSubview(view)
//        } else {
//            let view = UIView()
//            view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//            view.layer.cornerRadius = 5
//            view.clipsToBounds = true
//            view.heightAnchor.constraint(equalToConstant: height).isActive = true
//            //            verticalStackView.addArrangedSubview(amountLabel)
//            verticalStackView.addArrangedSubview(view)
//        }
//
//        //        let view = UIView()
//        //        view.backgroundColor = graphColor
//        //        view.layer.cornerRadius = 5
//        //        view.clipsToBounds = true
//        //        view.heightAnchor.constraint(equalToConstant: height).isActive = true
//        //
//        //        verticalStackView.addArrangedSubview(amountLabel)
//        //        verticalStackView.addArrangedSubview(view)
//
//        verticalStackView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
//        verticalStackView.translatesAutoresizingMaskIntoConstraints = false;
//
//        graphStackView.addArrangedSubview(verticalStackView)
//        graphStackView.translatesAutoresizingMaskIntoConstraints = false;
//    }
//
//    private func heightPixelsDependOfPercentage (percentage: Double) -> CGFloat {
//        let maxHeight: CGFloat = 90.0
//        return (CGFloat(percentage) * maxHeight) / 100
//    }
//
//    func setupViews() {
//        addSubViews(views: [graphStackView, indexStackView])
//    }
//
//    func setupLayout() {
//
////        graphView.snp.makeConstraints { (make) in
////            make.top.left.right.equalToSuperview()
////            make.height.equalTo(ConstraintConstants.h230)
////            make.width.equalToSuperview()
////        }
//
//        graphStackView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(ConstraintConstants.h20)
//            make.height.equalTo(ConstraintConstants.h110)
//            make.width.equalTo(ConstraintConstants.w300)
//            make.centerX.equalToSuperview()
//        }
//
//        indexStackView.snp.makeConstraints { (make) in
//            make.top.equalTo(graphStackView.snp.bottom).offset(ConstraintConstants.h5)
//            make.height.equalTo(ConstraintConstants.h15)
//            make.width.equalTo(ConstraintConstants.w300)
//            make.centerX.equalToSuperview()
//        }
//    }
//}
//
//extension BarGraphView : GraphRunningTimeView {
//
//    func updateInfo (runningTimeCollection: [TimeGraphData]){
//        removeAllGraphElements()
//        for timeGraphData in runningTimeCollection {
//            newGraphElement(timeGraphData: timeGraphData)
//        }
//    }
//}
