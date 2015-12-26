//
//  FormViewController.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

/**
 * `FormViewController` is a descendent of `UIViewController` used to display 
 * a `Form` in a UIKit application.
 *
 * In order to show a `Form` to a user, you will typically create a `Form`,
 * instantiate a `FormViewController`, set the `FormViewController`'s `form` 
 * property, and present the `FormViewController`.
 *
 * Where a `Form` refers to both the schema and data an application wishes to
 * obtain from a user, the `FormViewController` is an adapter that manages the
 * visual presentation of a `Form`, manages the lifecycle of interaction with 
 * the `Form`, and is a key point of interaction with the rest of an iOS 
 * application.
 *
 * - seealso: `Form`
 */
public class FormViewController: UIViewController, UITableViewDelegate {
    
    private var dataSource: FormDataSource?
    
    /**
     * The `Form` that the `FormViewController` presents to the user
     *
     * - seealso: `Form`
     */
    public var form :Form {
        didSet {
            form.editingEnabled = editingEnabled
            dataSource = FormDataSource(form: form, tableView: tableView)
            tableView?.dataSource = dataSource
        }
    }
    
    /**
     * The UITableView instance the `FormViewController` will populate with 
     * `Form` data.
     *
     * If this property is `nil` when `viewDidLoad` is called, the
     * `FormViewController` will create a `UITableView` and add it to its view
     * hierarchy.
     */
    public var tableView: UITableView!
    
    /**
     * The style of `tableView` to create in `viewDidLoad` if no `tableView` 
     * exists.
     *
     * Setting `tableViewStyle` only has an effect if set before `viewDidLoad` 
     * is called and the `FormViewController` does not yet have a `tableView`.
     * Otherwise its value is never read.
     *
     * - seealso: tableView
     */
    public var tableViewStyle: UITableViewStyle = .Grouped
    
    /**
     * Enables or disables editing of the represented `Form`.
     */
    public var editingEnabled :Bool = true {
        didSet {
            self.form.editingEnabled = editingEnabled
            if editing == false {
                self.tableView?.firstResponder()?.resignFirstResponder()
            }
            self.tableView?.reloadData()
        }
    }
    
    public init(form: Form) {
        self.form = form
        super.init(nibName: nil, bundle: nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        form = Form(sections: [])
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        form = Form(sections: [])
        super.init(coder: aDecoder)
    }
    
    private func link(form: Form, table: UITableView) {
        dataSource = FormDataSource(form: form, tableView: tableView)
        tableView.dataSource = dataSource
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if tableView == nil {
            tableView = UITableView(frame: view.bounds, style: tableViewStyle)
            tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        }
        if tableView.superview == nil {
            view.addSubview(tableView)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = 60
        tableView.delegate = self
        
        dataSource = FormDataSource(form: form, tableView: tableView)
        tableView.dataSource = dataSource
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
        if let cell = tableView.firstResponder()?.containingCell(),
            let selectedIndexPath = tableView.indexPathForCell(cell) {
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
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if let cell = cell as? FormTableViewCell {
            cell.formRow?.action?(nil)
            cell.action?(nil)
        }
        
        if let cell = cell as? ControllerSpringingCell, let controller = cell.nestedViewController {
            navigationController?.pushViewController(controller(), animated: true)
        }
    }
}
