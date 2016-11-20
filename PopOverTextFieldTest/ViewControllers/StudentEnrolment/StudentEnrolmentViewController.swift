//
//  StudentEnrolmentViewController.swift
//  PopOverTextFieldTest
//
//  Created by Pavan Kataria on 20/11/2016.
//  Copyright © 2016 Pavan Kataria. All rights reserved.
//

import UIKit

class StudentEnrolmentViewController: UIViewController {

    //MARK: - Public Properties
    let viewModel: StudentEnrolmentViewModel!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Lifecycle
    init(viewModel: StudentEnrolmentViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.viewModel.reloadData()
    }
    
    func setupTableView(){
        self.viewModel.viewModelTypes.forEach { $0.registerCell(tableView: self.tableView) }
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}
extension StudentEnrolmentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.viewModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.viewModel.viewModels[indexPath.section][indexPath.row].dequeueCell(tableView: tableView, indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
}
extension StudentEnrolmentViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.viewModels[indexPath.section][indexPath.row].heightForCell(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.viewModels[indexPath.section][indexPath.row].estimatedHeightForCell(tableView: tableView, indexPath: indexPath)
    }
}
