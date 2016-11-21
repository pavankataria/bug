//
//  TestCellViewModel.swift
//  KEC Enroller
//
//  Created by Pavan Kataria on 20/11/2016.
//  Copyright © 2016 Pavan Kataria. All rights reserved.
//

import Foundation
import UIKit

class TestCellViewModel {
    var rootView: UIView! = nil
    
    let genderOptions =  ["male", "female", "LGBT", "female", "male", "female", "male", "female", "male", "female", "male", "female", "male", "female", "male", "female", "male", "female"]
}

extension TestCellViewModel: CellRepresentable {
    static func registerCell(tableView: UITableView)
    {
        tableView.register(UINib.init(nibName: String(describing: TestTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TestTableViewCell.self))
    }

    func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TestTableViewCell.self), for: indexPath) as! TestTableViewCell
        cell.setup(self)
        return cell
    }
    
    func cellSelected()
    {
        print("cell selected")
    }
    func heightForCell(tableView: UITableView, indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func estimatedHeightForCell(tableView: UITableView, indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
