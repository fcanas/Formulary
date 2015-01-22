//
//  FormViewController.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

public class FormViewController: UIViewController, UITableViewDelegate {
    
    var dataSource: FormDataSource?
    
    public var form :Form! {
        didSet {
            if form != nil {
                dataSource = FormDataSource(form: form, tableView: tableView)
                tableView?.dataSource = dataSource
            } else {
                tableView?.dataSource = nil
            }
        }
    }
    var tableView: UITableView!
    var tableViewStyle: UITableViewStyle = .Grouped
    
    init(form: Form) {
        self.form = form
        super.init()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func link(form: Form, table: UITableView) {
        dataSource = FormDataSource(form: form, tableView: tableView)
        tableView.dataSource = dataSource
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if tableView == nil {
            tableView = UITableView(frame: view.bounds, style: tableViewStyle)
            tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        }
        if tableView.superview == nil {
            view.addSubview(tableView)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = 60
        tableView.delegate = self
        
        if form != nil {
            dataSource = FormDataSource(form: form, tableView: tableView)
            tableView.dataSource = dataSource
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let cell = tableView.firstResponder()?.containingCell()
        if let cell = cell {
            if let selectedIndexPath = tableView.indexPathForCell(cell) {
                let keyboardInfo = KeyboardNotification(notification)
                var keyboardEndFrame = keyboardInfo.screenFrameEnd
                keyboardEndFrame = view.window!.convertRect(keyboardEndFrame, toView: view)
                
                var contentInset = tableView.contentInset
                var scrollIndicatorInsets = tableView.scrollIndicatorInsets
                
                contentInset.bottom = tableView.frame.origin.y + self.tableView.frame.size.height - keyboardEndFrame.origin.y
                scrollIndicatorInsets.bottom = tableView.frame.origin.y + self.tableView.frame.size.height - keyboardEndFrame.origin.y
                
                UIView.beginAnimations("keyboardAnimation", context: nil)
                UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: keyboardInfo.animationCurve) ?? .EaseInOut)
                UIView.setAnimationDuration(keyboardInfo.animationDuration)
                
                tableView.contentInset = contentInset
                tableView.scrollIndicatorInsets = scrollIndicatorInsets
                
                tableView.scrollToRowAtIndexPath(selectedIndexPath, atScrollPosition: .None, animated: true)
                
                UIView.commitAnimations()
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let keyboardInfo = KeyboardNotification(notification)
        
        var contentInset = tableView.contentInset
        var scrollIndicatorInsets = tableView.scrollIndicatorInsets
        
        contentInset.bottom = 0
        scrollIndicatorInsets.bottom = 0
        
        UIView.beginAnimations("keyboardAnimation", context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: keyboardInfo.animationCurve) ?? .EaseInOut)
        UIView.setAnimationDuration(keyboardInfo.animationDuration)
        
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = scrollIndicatorInsets
        
        UIView.commitAnimations()
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tableView.firstResponder()?.resignFirstResponder()
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? FormTableViewCell {
            cell.formRow?.action?(nil)
        }
    }
}

extension UIView {
    func firstResponder() -> UIView? {
        if isFirstResponder() {
            return self
        }
        for subview in (subviews as [UIView]) {
            if let responder = subview.firstResponder() {
                return responder
            }
        }
        return nil
    }
    func containingCell() -> UITableViewCell? {
        if let c = self as? UITableViewCell {
            return c
        }
        return superview?.containingCell()
    }
}
