//
//  GenericTableView.swift
//  Meditatio kz
//
//  Created by Nazhmeddin Babakhanov on 11/10/2019.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//

import UIKit

protocol ConfigurableCells {
    
    associatedtype T
    
    func configure(_ : T)
    
}

protocol RowBuilder {
    
    var reusableId: String { get }
    
    func configure(cell: UITableViewCell, itemIndex: Int)
    
    var dataCount: Int { get }
    
    var cellType: AnyClass { get }
    
    var cellHeight: CGFloat { get }
    
    func cellAction(index: Int)
    
}

class TableRowBuilder<DataType, CellType: ConfigurableCells>: RowBuilder where CellType.T == DataType, CellType: UITableViewCell {
    
    
    func cellAction(index: Int) {
        return action(index)
    }
    
    
    var items = [DataType]()
    var heightForCells = UITableView.automaticDimension
    var action: ((Int) -> Void)!
    
    var reusableId: String {
        return String(describing: CellType.self)
    }
    
    func configure(cell: UITableViewCell, itemIndex: Int) {
        (cell as! CellType).configure(items[itemIndex])
    }
    
    var dataCount: Int {
        return items.count
    }
    
    init(items: [DataType], heightForCells: CGFloat = UITableView.automaticDimension, action: @escaping (_ indexOfCell: Int) -> Void) {
        self.items = items
        self.heightForCells = heightForCells
        self.action = action
    }
    
    var cellHeight: CGFloat {
        return heightForCells
    }
    
    var cellType: AnyClass {
        return CellType.self
    }
    
}

