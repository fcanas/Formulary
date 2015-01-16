//
//  FormViewController.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

public struct Form {
    public let sections: [FormSection]
    public init(sections: [FormSection]) {
        self.sections = sections
    }
}

public struct FormSection {
    public let name: String
    public let rows: [FormRow]
    public init(name: String, rows: [FormRow]) {
        self.name = name
        self.rows = rows
    }
}

public struct FormRow {
    public let name: String
    public init(name: String) {
        self.name = name
    }
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
    func allRows() -> [FormRow] {
        return sections.reduce(Array<FormRow>(), combine: { (rows, section) -> Array<FormRow> in
            return rows + section.rows
        })
    }
}

public class FormViewController: UIViewController {
    
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
        tableView.estimatedRowHeight = 44
        
        if form != nil {
            dataSource = FormDataSource(form: form, tableView: tableView)
            tableView.dataSource = dataSource
        }
    }
    
}

class FormDataSource: NSObject, UITableViewDataSource {
    let form: Form
    
    init(form: Form, tableView: UITableView) {
        self.form = form
        for row in form.allRows() {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: row.identifier())
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        println("sec:\(form.sections)")
        return countElements(form.sections)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("sec:\(form.sections[section])")
        return countElements(form.sections[section].rows)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = form.rowForIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(row.identifier()) as UITableViewCell
        cell.textLabel?.text = row.name
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return form.sections[section].name
    }
}


