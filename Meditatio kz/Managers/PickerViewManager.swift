//
//  PickerManager.swift
//  Jiber
//
//  Created by I on 10/2/19.
//  Copyright © 2019 Shyngys. All rights reserved.
//

import UIKit

class PickerViewManager: UIPickerView {

    var didSelect: ((String) -> ())?
//    var delegateView: PickerViewDelegate?
    var pickableItems: [String] = ["1", "2", "3", "4", "5", "6", "7"]

    override init(frame: CGRect) {
        super.init(frame: frame)

        delegeting()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func delegeting() -> Void {
        self.delegate = self
        self.dataSource = self
    }
}

extension PickerViewManager: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickableItems.isEmpty {
            return
        }

        didSelect?(self.pickableItems[row])
    }
}

extension PickerViewManager: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return pickableItems.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickableItems[row]
    }

}
