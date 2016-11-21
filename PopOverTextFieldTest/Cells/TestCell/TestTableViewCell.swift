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
//    @IBOutlet weak var genderTextfield: MLPAutoCompleteTextField!
    @IBOutlet weak var genderTextfield: PopOverTextField!
    @IBOutlet weak var backgroundPad: UIView!

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
        self.genderTextfield.popOverTableViewMaximumNumberOfOptionsToDisplay = 10
        self.genderTextfield.popOverTableViewRowHeight = self.genderTextfield.frame.height
        self.genderTextfield.popOverTextFieldParentView = viewModel.rootView
//        self.genderTextfield.autoCompleteParentView = viewModel.rootView
//        self.genderTextfield.maximumNumberOfAutoCompleteRows = 10
//        self.genderTextfield.autoCompleteDataSource = self
        
        let desiredPositionOnRedView = CGPoint(x: 0, y: self.genderTextfield.frame.maxY)
//        let desiredPositionOnRedView = CGPoint(x: self.backgroundPad.frame.origin.x, y: self.backgroundPad.frame.origin.y)
        
        let pointInCell = backgroundPad.convert(CGPoint(x: desiredPositionOnRedView.x, y: desiredPositionOnRedView.y), to: self)

        
        let pointInRootView = self.convert(CGPoint(x: pointInCell.x, y: pointInCell.y), to: viewModel.rootView)
        print(pointInRootView)
//        let pointb = self.convert(CGPoint(x: 0, y: pointa.y), to: viewModel.rootView)
        
        //        CGPoint pt = [textField convertPoint:CGPointMake(0, textField.frame.origin.y) toView:self.view];
//        self.genderTextfield.autoCompleteTableOriginOffset = CGSize(width: pointInRootView.x, height: pointInRootView.y);
        self.genderTextfield.popOverTableViewOriginOffset = CGSize(width: pointInRootView.x, height: pointInRootView.y);


    }
}

extension TestTableViewCell: MLPAutoCompleteTextFieldDataSource {
    func autoCompleteTextField(_ textField: MLPAutoCompleteTextField!, possibleCompletionsFor string: String!, completionHandler handler: (([Any]?) -> Void)!) {
        handler(["male", "female", "male", "female", "male", "female", "male", "female"])
    }
}
