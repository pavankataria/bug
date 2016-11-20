//
//  TestTableViewCell.swift
//  KEC Enroller
//
//  Created by Pavan Kataria on 20/11/2016.
//  Copyright © 2016 Pavan Kataria. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {

    //MARK: - Public Properties
    @IBOutlet weak var genderTextfield: PopOverTextField!

    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(_ viewModel: TestCellViewModel){
        self.genderTextfield.options = viewModel.genderOptions
        self.genderTextfield.popOverTableViewMaximumNumberOfOptionsToDisplay = 6
        self.genderTextfield.popOverTableViewRowHeight = self.genderTextfield.frame.height
    }
}
