//
//  PopOverTextField.swift
//  PopOverTextField
//
//  Created by Pavan Kataria on 16/11/2016.
//  Copyright © 2016 Pavan Kataria. All rights reserved.
//

import UIKit

protocol PopOverTextFieldDataSource {
    //    func numberOfRows(in popOverTextField: PopOverTextField) -> Int
    //    func textField(_ popOverTextField: PopOverTextField, titleForRow row: Int) -> String?
    
    //    func heightOfPopOver(for popOverTextField: PopOverTextField) -> CGFloat
}
protocol PopOverTextFieldDelegate {
    func popOverTextField(_ popOverTextField: PopOverTextField,
                          willHideTableView willHidePopOverTableView: UITableView)
    
    func popOverTextField(_ popOverTextField: PopOverTextField,
                          didHideTableView willHidePopOverTableView: UITableView)
    
    func popOverTextField(_ popOverTextField: PopOverTextField,
                          willShowTableView willShowPopOverTableView: UITableView)
    
    func popOverTextField(_ popOverTextField: PopOverTextField,
                          didShowTableView didShowPopOverTableView: UITableView)
}

class PopOverTextField: UITextField {
    
    //MARK: - Public Properties
    //    weak var popOverTextFieldDelegate: PopOverTextFieldDelegate? = nil
    var popOverTextFieldDelegate: PopOverTextFieldDelegate? = nil
    
    //TODO: Add ability to add an arrow to the pop over view like a class UIPopOverPresentationController class, which offsets the tableview position even further down. Might have to add a border around the table too or not necessarily.
    
    var options: Array<String> = []
    weak var popOverTextFieldParentView: UIView? = nil
    var popOverTextFieldAllowsKeyboardInput = false
    var popOverTableViewCornerRadius: CGFloat = 8
    var popOverTableViewMaximumNumberOfOptionsToDisplay: NSInteger = 3
    var popOverTableViewLastVisibleRowHeightToTrim: CGFloat = 0.4
    var popOverTableViewRowHeight: CGFloat = 40
    var popOverTableViewShouldDismissOnOptionSelection: Bool = true
    var popOverTableViewOriginOffset: CGSize = CGSize(width: 0, height: 0)
    
    //MARK: - Private Properties
    private(set) var popOverTableView: UITableView = UITableView()
    
    
    fileprivate var cornerRadiiCompensation: CGSize {
        //        let tableViewOffset = self.popOverTableViewOriginOffset
        let cornerRadiusCompensation = self.popOverTableViewCornerRadius + self.layer.cornerRadius
        return CGSize(width: 0, height: cornerRadiusCompensation)
    }
    fileprivate var popOverTableViewContentInset: UIEdgeInsets {
        return UIEdgeInsets(top: self.cornerRadiiCompensation.height, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate var maxHeightMultiplier: CGFloat {
        if self.popOverTableViewMaximumNumberOfOptionsToDisplay == 1 {
            return 2 - self.popOverTableViewLastVisibleRowHeightToTrim
        }
        else {
            return CGFloat(self.popOverTableViewMaximumNumberOfOptionsToDisplay) - self.popOverTableViewLastVisibleRowHeightToTrim
        }
    }
    
    override var frame: CGRect {
        didSet {
            self.updatePopOverTableViewFrame()
        }
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    deinit {
        self.unregisterKeyPaths()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setup(){
        self.registerKeyPaths()
        self.clipsToBounds = false
        self.popOverTableView = self.createPopOverTableView(for: self)
        
        self.stylise(self.popOverTableView)
    }
    
    func registerKeyPaths(){
        self.addTarget(self, action: #selector(PopOverTextField.textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        self.addTarget(self, action: #selector(PopOverTextField.textFieldDidEndEditing(_:)), for: .editingDidEnd)
        self.addTarget(self, action: #selector(PopOverTextField.textFieldDidChange(_:)), for: .editingChanged)
        //        self.layer.addObserver(self, forKeyPath: "cornerRadius", options: .new, context: nil)
        addObserver(self, forKeyPath: #keyPath(layer.cornerRadius), options: [.new], context: nil)
    }
    
    func unregisterKeyPaths(){
        self.removeTarget(self, action: nil, for: .editingDidBegin)
    }
    
    //MARK: - Events
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(layer.cornerRadius) {
            self.updatePopOverTableViewFrame()
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        self.applyShadowProperties(to: self)
        self.addPopOverView()
        self.popOverTableView.reloadData()
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        self.revertToOriginalShadowProperties(for: self)
        self.popOverTableView.removeFromSuperview()
        return super.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: PopOverTextField){
        
        
        //        self.superview?.insertSubview(popOverTableView, belowSubview: self)
        //        let point = self.convert(CGPoint.init(x: 0, y: self.frame.maxY), to: self.view)
        //        CGPoint pt = [textField convertPoint:CGPointMake(0, textField.frame.origin.y) toView:self.view];
        //        self.popOverTableViewOriginOffset = CGSize(width: 40, height: point.y);
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        print("Did end editing")
    }
    
    func textFieldDidChange(_ textField: PopOverTextField){
        print(textField.text ?? "")
        self.reload()
    }
    
    func reload(){
        
    }
    
    func updatePopOverTableViewFrame(){
        self.popOverTableView.frame = self.createPopOverTableViewFrame(for: self)
        self.popOverTableView.contentInset = self.popOverTableViewContentInset
        self.popOverTableView.scrollIndicatorInsets = self.popOverTableViewContentInset
    }
    func selectOption(_ row: NSInteger){
        self.text = nil
        self.text = self.options[row]
        
        self.hidePopOver()
    }
    
    
    override func layoutSubviews() {
        //https://forums.developer.apple.com/thread/12387
        //http://stackoverflow.com/questions/31429147/uitableview-separator-not-hiding-for-ios9
        super.layoutSubviews()
        popOverTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        popOverTableView.separatorColor = UIColor.clear
    }
    
    
    
}

//MARK: - SHOW/HIDE
extension PopOverTextField {
    func addPopOverView(){
        let v = (self.popOverTextFieldParentView != nil) ? self.popOverTextFieldParentView : self.superview
        v!.bringSubview(toFront: self)
        v!.insertSubview(self.popOverTableView, belowSubview: self)
    }
    func showPopOver(with rowCount: NSInteger){
        self.popOverTableView.isUserInteractionEnabled = true
        
        self.popOverTextFieldDelegate?.popOverTextField(self, willShowTableView: self.popOverTableView)
        
        
        var tableViewFrame = self.createPopOverTableViewFrame(for: self)
        let popOverTableViewHeight = self.calculatePopOverTableViewHeight(with: rowCount)
        tableViewFrame.size.height = popOverTableViewHeight + self.cornerRadiiCompensation.height
        
        self.popOverTableView.frame = tableViewFrame
        self.popOverTableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        self.popOverTextFieldDelegate?.popOverTextField(self, didShowTableView: self.popOverTableView)
    }
    
    func hidePopOver(){
        guard self.popOverTableViewShouldDismissOnOptionSelection else {
            return
        }
        self.popOverTextFieldDelegate?.popOverTextField(self, willHideTableView: self.popOverTableView)
        _ = self.resignFirstResponder()
        self.popOverTextFieldDelegate?.popOverTextField(self, didHideTableView: self.popOverTableView)
    }
}

extension PopOverTextField: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = self.options.count
        self.showPopOver(with: rowCount)
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel!.text = self.options[indexPath.row]
        cell.backgroundColor = UIColor.yellow
        return cell
    }
}

extension PopOverTextField: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.popOverTableViewRowHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectOption(indexPath.row)
    }
}

//MARK: - Create
extension PopOverTextField {
    func createPopOverTableView(for textField: PopOverTextField) -> UITableView {
        let popOverTableViewFrame = self.createPopOverTableViewFrame(for: textField)
        
        let tableView = UITableView.init(frame: popOverTableViewFrame, style: .plain)
        tableView.contentInset = self.popOverTableViewContentInset
        tableView.delegate = textField
        tableView.dataSource = textField
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: 30)
        tableView.isScrollEnabled = true
        tableView.backgroundColor = UIColor.green
        return tableView
    }
    
    func createPopOverTableViewFrame(for textField: PopOverTextField) -> CGRect {
        let x = textField.frame.minX + self.cornerRadiiCompensation.width + self.popOverTableViewOriginOffset.width
        let y = textField.frame.maxY - self.cornerRadiiCompensation.height + self.popOverTableViewOriginOffset.height
        let width = textField.frame.width
        let height = textField.frame.height
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func calculatePopOverTableViewHeight(with numberOfRows: NSInteger) -> CGFloat {
        
        let heightMultiplier: CGFloat
        if numberOfRows >= self.popOverTableViewMaximumNumberOfOptionsToDisplay {
            heightMultiplier = self.maxHeightMultiplier
        }
        else {
            heightMultiplier = CGFloat(numberOfRows)
        }
        let tableViewHeight: CGFloat = heightMultiplier * self.popOverTableViewRowHeight// + self.tableViewOriginOffset.height
        
        return tableViewHeight
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print(point)
        return super.hitTest(point, with: event)
    }
    
}

//MARK: - Style
extension PopOverTextField {
    func stylise(_ popOverTableView: UITableView)
    {
        self.roundCorners([.bottomLeft , .bottomRight], for:popOverTableView)
    }
    
    func roundCorners(_ corners: UIRectCorner, for view: UIView)
    {
        view.layer.cornerRadius = self.popOverTableViewCornerRadius
    }
    
    func applyShadowProperties(to popOverTextField: PopOverTextField)
    {
        //TODO: Make these settable shadow_properties
        popOverTextField.layer.shadowColor = UIColor.black.cgColor
        popOverTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        popOverTextField.layer.shadowOpacity = 0.5
        //        popOverTextField.layer.shadowRadius = 5.0
        popOverTextField.layer.masksToBounds =  false
    }
    
    func revertToOriginalShadowProperties(for popOverTextField: PopOverTextField) {
        //TODO: Make these settable original_shadow_properties
        //        popOverTextField.layer.shadowColor = original
        //        popOverTextField.layer.shadowOffset = original
        //        popOverTextField.layer.shadowOpacity = original
        //        popOverTextField.layer.shadowRadius = original
        //        popOverTextField.layer.masksToBounds = original
        popOverTextField.layer.shadowOpacity = 0
    }
}
