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

func configureCell(cell: UITableViewCell, inout row: FormRow) {
    cell.textLabel?.text = row.name
    switch row.type {
    case .Plain:
        break
    case .Switch:
        let s = UISwitch()
        cell.accessoryView = s
        ActionTarget(control: s, controlEvents: .ValueChanged, action: { (_) -> Void in
            row.value = s.on
        })
        
        if let enabled = row.value as? Bool {
            s.on = enabled
        }
    }
}

let r :UnsafePointer<Void> = UnsafePointer<Void>()

class ActionTarget {
    let control: UIControl
    let closure: (UIControl) -> Void
    init(control: UIControl, controlEvents: UIControlEvents, action: (AnyObject?) -> Void) {
        self.control = control
        closure = action
        control.addTarget(self, action: Selector("action:"), forControlEvents: controlEvents)
        
        objc_setAssociatedObject(control, r, self, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }
    
    @objc func action(sender: UIControl) {
        closure(sender)
    }
}
    
