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
        tableView.registerFormCellClasses(FormDataSource.cellRegistry)
    }
    
    // MARK: Data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return form.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rowForIndexPath(indexPath, form: form)
        var cell = tableView.dequeueReusableCell(withIdentifier: row.cellIdentifier) as! FormTableViewCell
        cell.formRow = row
        if let _ = cell as? ControllerSpringingCell, let cell = cell as? UITableViewCell {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        return cell as! UITableViewCell
    }
    
    // MARK: Headers and Footers
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return form.sections[section].name
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return form.sections[section].footerName
    }
    
    // MARK: Cell Registration
    
    // Key: reuseidentifier, Value: Class Name
    // Currently, this isn't stored as [String : AnyClass] due to ObjC interop
    // issues. If you can get it to work with that, please make the change
    static var cellRegistry :[String : String] = [:]
    
    class func registerClass(_ cellClass :AnyClass, forCellReuseIdentifier identifier: String) {
        cellRegistry[identifier] = NSStringFromClass(cellClass)
    }
}
