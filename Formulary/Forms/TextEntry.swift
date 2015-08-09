//
//  TextEntry.swift
//  Formulary
//
//  Created by Fabian Canas on 1/17/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

//MARK: Sub-Types

public enum TextEntryType: String {
    case Plain   = "Formulary.Plain"
    case Number  = "Formulary.Number"
    case Decimal = "Formulary.Decimal"
    case Email   = "Formulary.Email"
    case Twitter = "Formulary.Twitter"
    case URL     = "Formulary.URL"
}

//MARK: Form Row

public class TextEntryFormRow : FormRow {
    public let textType: TextEntryType
    public let formatter: NSFormatter?
    
    public init(name: String, tag: String, textType: TextEntryType = .Plain, value: AnyObject? = nil, validation: Validation = PermissiveValidation, formatter: NSFormatter? = nil, action: Action? = nil) {
        self.textType = textType
        self.formatter = formatter
        super.init(name: name, tag: tag, type: .Specialized, value: value, validation: validation, action: action)
    }
}

//MARK: Cell

class TextEntryCell: UITableViewCell, FormTableViewCell {
    
    var configured: Bool = false
    var action :Action?
    
    var textField :NamedTextField?
    
    var formRow :FormRow? {
        didSet {
            if var formRow = formRow as? TextEntryFormRow {
                switch formRow.textType {
                case .Plain:
                    configureTextField(&formRow).keyboardType = .Default
                case .Number:
                    configureTextField(&formRow).keyboardType = .NumberPad
                case .Decimal:
                    configureTextField(&formRow).keyboardType = .DecimalPad
                case .Email:
                    configureTextField(&formRow).keyboardType = .EmailAddress
                case .Twitter:
                    configureTextField(&formRow).keyboardType = .Twitter
                case .URL:
                    configureTextField(&formRow).keyboardType = .URL
                }
            }
            selectionStyle = .None
        }
    }
    
    func configureTextField(inout row: TextEntryFormRow) -> UITextField {
        if (textField == nil) {
            let newTextField = NamedTextField(frame: contentView.bounds)
            newTextField.setTranslatesAutoresizingMaskIntoConstraints(false)
            contentView.addSubview(newTextField)
            textField = newTextField
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[textField]-|", options: nil, metrics: nil, views: ["textField":newTextField]))
            textField = newTextField
        }
        
        textField?.text = row.value as? String
        textField?.placeholder = row.name
        textField?.validation = row.validation
        textField?.setFormatter(row.formatter)
        
        map(textField, { (field :NamedTextField) -> ActionTarget in
            ActionTarget.clear(field, controlEvents: .EditingChanged)
            return ActionTarget(control: field, controlEvents: .EditingChanged, action: { _ in
                row.value = field.text
            })
        })
        configured = true
        return textField!
    }
}
