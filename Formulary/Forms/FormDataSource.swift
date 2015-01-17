//
//  FormDataSource.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

class FormDataSource: NSObject, UITableViewDataSource {
    let form: Form
    
    init(form: Form, tableView: UITableView) {
        self.form = form
        for row in allRows(form) {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: row.identifier())
        }
    }
    
    // MARK: Data
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return countElements(form.sections)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countElements(form.sections[section].rows)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = rowForIndexPath(indexPath, form)
        let cell = tableView.dequeueReusableCellWithIdentifier(row.identifier()) as UITableViewCell
        configureCell(cell, row)
        return cell
    }
    
    // MARK: Headers and Footers
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return form.sections[section].name
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return form.sections[section].footerName
    }
}
