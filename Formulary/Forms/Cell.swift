//
//  Cell.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

protocol FormTableViewCell {
    var configured: Bool { get set }
    var formRow: FormRow? { get set }
    var action :Action? { get set }
}

public enum FormRowType: String {
    case Switch  = "Formulary.Switch"
    case Button  = "Formulary.Button"
    case Toggle  = "Formulary.Toggle"
    case Specialized = "__Formulary.Specialized"
}

extension UITableView {
    func registerFormCellClasses() {
        self.registerClass(BasicFormCell.self, forCellReuseIdentifier: FormRowType.Switch.rawValue)
        self.registerClass(BasicFormCell.self, forCellReuseIdentifier: FormRowType.Button.rawValue)
        self.registerClass(BasicFormCell.self, forCellReuseIdentifier: FormRowType.Toggle.rawValue)
        
        self.registerClass(TextEntryCell.self, forCellReuseIdentifier: TextEntryType.Plain.rawValue)
        self.registerClass(TextEntryCell.self, forCellReuseIdentifier: TextEntryType.Number.rawValue)
        self.registerClass(TextEntryCell.self, forCellReuseIdentifier: TextEntryType.Decimal.rawValue)
        self.registerClass(TextEntryCell.self, forCellReuseIdentifier: TextEntryType.Email.rawValue)
        self.registerClass(TextEntryCell.self, forCellReuseIdentifier: TextEntryType.Twitter.rawValue)
        self.registerClass(TextEntryCell.self, forCellReuseIdentifier: TextEntryType.URL.rawValue)
    }
}

class BasicFormCell :UITableViewCell, FormTableViewCell {
    
    var configured: Bool = false
    var action :Action?
    
    var formRow :FormRow? {
        didSet {
            if var formRow = formRow {
                configureCell(&formRow)
            }
        }
    }
    
    func configureCell(inout row: FormRow) {
        
        action = nil
        
        switch row.type {
        case .Switch:
            textLabel?.text = row.name
            let s = UISwitch()
            accessoryView = s
            ActionTarget(control: s, action: { _ in
                row.value = s.on
            })
            
            if let state = row.value as? Bool {
                s.on = state
            }
            
            s.enabled = row.enabled
            
        case .Toggle:
            textLabel?.text = row.name
            accessoryType = ((row.value as? Bool) ?? false) ? UITableViewCellAccessoryType.Checkmark : .None
            
            if row.enabled {
                action = { x in
                    self.accessoryType = ((row.value as? Bool) ?? false) ? UITableViewCellAccessoryType.Checkmark : .None
                }
            }
            
        case .Button:
            let button = UIButton(frame: bounds)
            
            button.setTitle(row.name, forState: .Normal)
            button.setTitleColor(tintColor, forState: .Normal)
            
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
            contentView.addSubview(button)
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[button]-|", options: nil, metrics: nil, views: ["button":button]))
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[button]-|", options: nil, metrics: nil, views: ["button":button]))
            
            var emptyAction :Action = { _ in }
            
            if row.enabled {
                ActionTarget(control: button, controlEvents: UIControlEvents.TouchUpInside, action: row.action ?? emptyAction)
            }
        case .Specialized:
            assert(false, "Specialized cells should not be configured here.")
        }
        selectionStyle = .None
    }
}
