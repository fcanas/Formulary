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
public class FormViewController: UIViewController {
    
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
    
    lazy private var tableViewDelegate :FormViewControllerTableDelegate = {
        return FormViewControllerTableDelegate(formViewController: self)
    }()
    
    /**
     * Returns a newly initialized form view controller with the nib file in the
     * specified bundle and ready to represent the specified Form.
     *
     * - parameters:
     *   - form: The Form to show in the FormViewController
     *   - nibName: The name of the nib file to associate with the view controller. The nib file name should not contain any leading path information. If you specify nil, the nibName property is set to nil.
     *   - nibBundle: The bundle in which to search for the nib file. This method looks for the nib file in the bundle's language-specific project directories first, followed by the Resources directory. If this parameter is nil, the method uses the heuristics described below to locate the nib file.
     */
    public init(form: Form = Form(sections: []), nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.form = form
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /**
     * Returns a newly initialized FormViewController with a Form
     *
     * - parameter: form The Form to show in the FormViewController
     */
    public convenience init(form: Form) {
        self.init(form: form, nibName: nil, bundle: nil)
    }
    
    /**
     * Returns a newly initialized FormViewController with an empty Form.
     *
     * Use this convenience initializer for compatibility with generic UIKit
     * view controllers. It is perfectly acceptable to create a Form and assign 
     * it to the FormViewController after initialization.
     */
    public override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.init(form: Form(sections: []), nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /**
     * Returns a newly initialized FormViewController with an empty Form.
     *
     * Use this convenience initializer for compatibility with generic UIKit
     * view controllers. It is perfectly acceptable to create a Form and assign
     * it to the FormViewController after initialization.
     */
    public required init?(coder aDecoder: NSCoder) {
        form = Form(sections: [])
        super.init(coder: aDecoder)
    }
    
    private func link(form: Form, table: UITableView) {
        dataSource = FormDataSource(form: form, tableView: tableView)
        tableView.dataSource = dataSource
    }
    
    /**
     * Called by UIKit after the controller's view is loaded into memory.
     *
     * FormViewController implements custom logic to ensure that a Form can be 
     * correctly displayed regarless of how it was constructed. This includes 
     * creating and configuring a Table View and constructing a private data
     * source for the table view.
     *
     * You typically will not need to override -viewDidLoad in subclasses of
     * FormViewController. But if you do, things will work better if you invoke
     * the superclass's implementation first.
     */
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
        tableView.delegate = tableViewDelegate
        
        dataSource = FormDataSource(form: form, tableView: tableView)
        tableView.dataSource = dataSource
    }
    
    /**
     * If you override this method, you must call super at some point in your 
     * implementation.
     */
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
     * If you override this method, you must call super at some point in your 
     * implementation.
     */
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

private extension FormViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
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
    
    @objc func keyboardWillHide(notification: NSNotification) {
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
}

private class FormViewControllerTableDelegate :NSObject, UITableViewDelegate {
    
    weak var formViewController :FormViewController?
    
    init(formViewController :FormViewController) {
        super.init()
        self.formViewController = formViewController
    }
    
    @objc func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        formViewController?.tableView.firstResponder()?.resignFirstResponder()
    }
    
    @objc func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if let cell = cell as? FormTableViewCell {
            cell.formRow?.action?(nil)
            cell.action?(nil)
        }
        
        if let cell = cell as? ControllerSpringingCell, let controller = cell.nestedViewController {
            formViewController?.navigationController?.pushViewController(controller(), animated: true)
        }
    }
}
