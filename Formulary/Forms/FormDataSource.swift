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
