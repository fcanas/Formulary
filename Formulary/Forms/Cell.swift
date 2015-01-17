//
//  Cell.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

extension UITableView {
    func registerFormCellClasses() {
        self.registerClass(UITableViewCell.self, forCellReuseIdentifier: FormRowType.Plain.rawValue)
        self.registerClass(UITableViewCell.self, forCellReuseIdentifier: FormRowType.Switch.rawValue)
    }
}

func configureCell(cell: UITableViewCell, row: FormRow) {
    cell.textLabel?.text = row.name
    switch row.type {
    case .Plain:
        break
    case .Switch:
        let s = UISwitch()
        cell.accessoryView = s
        if let enabled = row.value as? Bool {
            s.on = enabled
        }
    }
}