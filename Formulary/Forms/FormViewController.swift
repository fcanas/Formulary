//
//  FormViewController.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

struct Form {
    let sections: [FormSection]
}

struct FormSection {
    let rows: [FormRow]
}

struct FormRow {
    
}

extension FormRow {
    func identifier() -> String {
        return "FormRow"
    }
}

extension Form {
    func rowForIndexPath(indexPath: NSIndexPath) -> FormRow {
        return sections[indexPath.section].rows[indexPath.row]
    }
}

public class FormViewController: UIViewController {
    
    var form :Form! {
        didSet {
            if form != nil {
                tableView?.dataSource = FormDataSource(form: form, tableView: tableView)
            } else {
                tableView?.dataSource = nil
            }
            tableView?.reloadData()
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
        tableView.estimatedRowHeight = 44
        
        if form != nil {
            tableView.dataSource = FormDataSource(form: form, tableView: tableView)
        }
    }
    
}

class FormDataSource: NSObject, UITableViewDataSource {
    let form: Form
    
    init(form: Form, tableView: UITableView) {
        self.form = form
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return countElements(form.sections)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countElements(form.sections[section].rows)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(form.rowForIndexPath(indexPath).identifier()) as UITableViewCell
        return cell
    }
}


