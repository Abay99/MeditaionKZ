//
//  DatePickerManager.swift
//  Jiber
//
//  Created by I on 10/2/19.
//  Copyright © 2019 Shyngys. All rights reserved.
//

import UIKit

class DatePickerViewManager: UIDatePicker {

    var valueChanged: ((String) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConfiguration() -> Void {
        self.minimumDate = Date()
        self.maximumDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        self.addTarget(self, action: #selector(valueChangedEvent), for: .valueChanged)
    }
}

//  MARK: Target actions
extension DatePickerViewManager {

    @objc func valueChangedEvent() -> Void {

        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        valueChanged?(formatter.string(from: self.date))
    }
}
