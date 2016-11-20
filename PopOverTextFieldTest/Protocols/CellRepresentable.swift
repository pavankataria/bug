//
//  CellRepresentable.swift
//  Drift
//
//  Created by Pavan Kataria on 26/05/2016.
//  Copyright © 2016 SimpleCat. All rights reserved.
//

//TODO: See if NSObjectProtocol will work without any errors in project. For optional methods
import UIKit

protocol CellRepresentable {
    static func registerCell(tableView: UITableView)

    func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    
    func dequeueHeader(tableView: UITableView, section: Int) -> UIView?
    
    func heightForCell(tableView: UITableView, indexPath: IndexPath) -> CGFloat
    func willDisplayCell(tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath)
    func didEndDisplayCell(tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath)
    func estimatedHeightForCell(tableView: UITableView, indexPath: IndexPath) -> CGFloat
    func cellSelected()
}

//MARK: - Default Implementation
extension CellRepresentable {
    func dequeueHeader(tableView: UITableView, section: Int) -> UIView? {
        return nil
    }
    func heightForCell(tableView: UITableView, indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func willDisplayCell(tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath){}
    func didEndDisplayCell(tableView: UITableView, cell: UITableViewCell, indexPath: IndexPath){}
    func cellSelected(){}
    
}
