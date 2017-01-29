//
//  Cell.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

/// A protocol with requirements for UITableViewCell subclasses to be used in
/// a table view showing a Form.
public protocol FormTableViewCell {
    /// Indicates whether the cell has been configured
    var configured: Bool { get set }
    /// The FormRow model object the cell represents, if any
    var formRow: FormRow? { get set }
    /// An optional Action associated with the cell. Typically gets executed when the cell is tapped.
    var action :Action? { get set }
}

/**
 * Describes a type of cell that presents a view controller when pressed.
 *
 * To present a view controller from a FormRow, create and register a specialized
 * FormRow type, and associate it with a FormRow cell class that implements
 * `ControllerSpringingCell`. Use this property on the cell to pass in a closure
 * that returns the view controller to be presented. The view controller could
 * be created dynamically within the closure, or captured in the closure scope.
 *
 * - seealso: FormTableViewCell,
 */
public protocol ControllerSpringingCell {
    /**
     * A closure that returns the view controller to be presented. The view 
     * controller could be created dynamically within the closure, or captured 
     * in the closure scope.
     */
    var nestedViewController :(() -> UIViewController)? { get set }
}

/**
 * The type of FormRow.
 */
public enum FormRowType: String {
    /// A FormRow shoing a Boolean switch
    case Switch  = "Formulary.Switch"
    /// A FormRow representing a Button to perform an action
    case Button  = "Formulary.Button"
    /// A FormRow whose state is toggled when pressed
    case Toggle  = "Formulary.Toggle"
    /// All other types of FormRows, including Number and Text Entry
    case Specialized = "__Formulary.Specialized"
}

extension UITableView {
    func registerFormCellClasses(_ classes :[String : String]) {
        for (identifier, klass) in classes {
            self.register(NSClassFromString(klass), forCellReuseIdentifier: identifier)
        }
        
        self.register(BasicFormCell.self, forCellReuseIdentifier: FormRowType.Switch.rawValue)
        self.register(BasicFormCell.self, forCellReuseIdentifier: FormRowType.Button.rawValue)
        self.register(BasicFormCell.self, forCellReuseIdentifier: FormRowType.Toggle.rawValue)
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
    
    func configureCell(_ row: inout FormRow) {
        
        action = nil
        contentView.addConstraints([NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 60.0)])
        
        switch row.type {
        case .Switch:
            textLabel?.text = row.name
            let s = UISwitch()
            accessoryView = s
            bind(s, action: { [s, row] _ in
                row.value = s.isOn as AnyObject?
            })
            
            if let state = row.value as? Bool {
                s.isOn = state
            }
            
            s.isEnabled = row.enabled
            
        case .Toggle:
            textLabel?.text = row.name
            accessoryType = ((row.value as? Bool) ?? false) ? UITableViewCellAccessoryType.checkmark : .none
            
            if row.enabled {
                action = { [row] x in
                    self.accessoryType = ((row.value as? Bool) ?? false) ? UITableViewCellAccessoryType.checkmark : .none
                }
            }
            
        case .Button:
            let button = UIButton(frame: bounds)
            
            button.setTitle(row.name, for: UIControlState())
            button.setTitleColor(tintColor, for: UIControlState())
            
            button.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(button)
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[button]-|", options: [], metrics: nil, views: ["button":button]))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[button]-|", options: [], metrics: nil, views: ["button":button]))
            
            let action :Action
            
            if let rowAction = row.action {
                action = rowAction
            } else {
                action = { _ in }
            }
            
            if row.enabled {
                bind(button, controlEvents: UIControlEvents.touchUpInside, action: action)
            }
        case .Specialized:
            assert(false, "Specialized cells should not be configured here.")
        }
        selectionStyle = .none
    }
}
