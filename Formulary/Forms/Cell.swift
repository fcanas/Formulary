//
//  Cell.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

public enum FormRowType: String {
    case Plain   = "Formulary.Plain"
    case Switch  = "Formulary.Switch"
    case Button  = "Formulary.Button"
    case Toggle  = "Formulary.Toggle"
    
    // Text
    case Text    = "Formulary.Text"
    case Number  = "Formulary.Number"
    case Decimal = "Formulary.Decimal"
    case Email   = "Formulary.Email"
    case Twitter = "Formulary.Twitter"
    case URL     = "Formulary.URL"
}

extension UITableView {
    func registerFormCellClasses() {
        self.registerClass(FormTableViewCell.self, forCellReuseIdentifier: FormRowType.Plain.rawValue)
        self.registerClass(FormTableViewCell.self, forCellReuseIdentifier: FormRowType.Switch.rawValue)
        self.registerClass(FormTableViewCell.self, forCellReuseIdentifier: FormRowType.Button.rawValue)
        self.registerClass(FormTableViewCell.self, forCellReuseIdentifier: FormRowType.Toggle.rawValue)
        
        self.registerClass(FormTableViewCell.self, forCellReuseIdentifier: FormRowType.Text.rawValue)
        self.registerClass(FormTableViewCell.self, forCellReuseIdentifier: FormRowType.Number.rawValue)
        self.registerClass(FormTableViewCell.self, forCellReuseIdentifier: FormRowType.Decimal.rawValue)
        self.registerClass(FormTableViewCell.self, forCellReuseIdentifier: FormRowType.Email.rawValue)
        self.registerClass(FormTableViewCell.self, forCellReuseIdentifier: FormRowType.Twitter.rawValue)
        self.registerClass(FormTableViewCell.self, forCellReuseIdentifier: FormRowType.URL.rawValue)
    }
}

func configureCell(cell: FormTableViewCell, inout row: FormRow) {
    
    cell.action = nil
    cell.formRow = row
    
    switch row.type {
    case .Plain:
        cell.textLabel?.text = row.name
        break
    case .Switch:
        cell.textLabel?.text = row.name
        let s = UISwitch()
        cell.accessoryView = s
        ActionTarget(control: s, action: { _ in
            row.value = s.on
        })
        
        if let enabled = row.value as? Bool {
            s.on = enabled
        }
    case .Toggle:
        cell.textLabel?.text = row.name
        cell.accessoryType = ((row.value as? Bool) ?? false) ? UITableViewCellAccessoryType.Checkmark : .None
        
        cell.action = { x in
            cell.accessoryType = ((row.value as? Bool) ?? false) ? UITableViewCellAccessoryType.Checkmark : .None
        }
        
    case .Button:
        let button = UIButton(frame: cell.bounds)
        
        button.setTitle(row.name, forState: .Normal)
        button.setTitleColor(cell.tintColor, forState: .Normal)

        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        cell.contentView.addSubview(button)
        cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[button]-|", options: nil, metrics: nil, views: ["button":button]))
        cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[button]-|", options: nil, metrics: nil, views: ["button":button]))
        
        var emptyAction :Action = { _ in }
        
        ActionTarget(control: button, controlEvents: UIControlEvents.TouchUpInside, action: row.action ?? emptyAction)
    case .Text:
        configureTextCell(cell, &row).keyboardType = .Default
    case .Number:
        configureTextCell(cell, &row).keyboardType = .NumberPad
    case .Decimal:
        configureTextCell(cell, &row).keyboardType = .DecimalPad
    case .Email:
        configureTextCell(cell, &row).keyboardType = .EmailAddress
    case .Twitter:
        configureTextCell(cell, &row).keyboardType = .Twitter
    case .URL:
        configureTextCell(cell, &row).keyboardType = .URL
    }
    cell.selectionStyle = .None
}

let FormInputAccessory = TraversalInputAccessory(frame: CGRectZero)

func configureTextCell(cell: FormTableViewCell, inout row: FormRow) -> UITextField {
    var textField :NamedTextField?
    if (cell.textField == nil) {
        let newTextField = NamedTextField(frame: cell.contentView.bounds)
        newTextField.inputAccessoryView = FormInputAccessory
        newTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
        cell.contentView.addSubview(newTextField)
        cell.textField = newTextField
        cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[textField]-|", options: nil, metrics: nil, views: ["textField":newTextField]))
        textField = newTextField
    } else {
        textField = cell.textField
    }
    
    textField?.text = row.value as? String
    textField?.placeholder = row.name
    textField?.validation = row.validation
    
    map(textField, { (field :NamedTextField) -> ActionTarget in
        ActionTarget.clear(field, controlEvents: .EditingChanged)
        return ActionTarget(control: field, controlEvents: .EditingChanged, action: { _ in
            row.value = field.text
        })
    })
    
    return textField!
}

class FormTableViewCell: UITableViewCell {
    var configured: Bool = false
    var formRow: FormRow?
    var action :Action?
    var textField :NamedTextField?
}

let ActionTargetControlKey :UnsafePointer<Void> = UnsafePointer<Void>()

class ActionTarget {
    let control: UIControl
    let closure: (UIControl) -> Void
    init(control: UIControl, controlEvents: UIControlEvents = .ValueChanged, action: (UIControl) -> Void) {
        self.control = control
        closure = action
        control.addTarget(self, action: Selector("action:"), forControlEvents: controlEvents)
        
        objc_setAssociatedObject(control, ActionTargetControlKey, self, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }
    
    @objc func action(sender: UIControl) {
        closure(sender)
    }
    
    class func clear(control :UIControl, controlEvents :UIControlEvents) {
        if let target = objc_getAssociatedObject(control, ActionTargetControlKey) as? ActionTarget {
            control.removeTarget(target, action: Selector("action:"), forControlEvents: controlEvents)
        }
    }
}
    
