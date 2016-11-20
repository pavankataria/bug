//
//  StudentEnrolmentViewModel.swift
//  PopOverTextFieldTest
//
//  Created by Pavan Kataria on 20/11/2016.
//  Copyright © 2016 Pavan Kataria. All rights reserved.
//

import Foundation

class StudentEnrolmentViewModel {
    
    //MARK: - Properties
    let viewModelTypes: [CellRepresentable.Type] = [
        TestCellViewModel.self
    ]
    
    //MARK: - Private Properties
    private(set) var viewModels = [[CellRepresentable]]()
    
    //MARK: - Events
    func reloadData(){
        self.viewModels = self.prepareViewModels()
    }
}

//MARK: - Preparing
extension StudentEnrolmentViewModel
{
    func prepareViewModels() -> [[CellRepresentable]]
    {
        return [
            self.prepareTestTableViewCell(),
        ]
    }
}

//MARK: - Test Cell View Model
extension StudentEnrolmentViewModel {
    func prepareTestTableViewCell() -> [CellRepresentable]
    {
        let instance = TestCellViewModel()
        return [instance]
    }
}
