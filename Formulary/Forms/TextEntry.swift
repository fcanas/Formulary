//
//  TextEntry.swift
//  Formulary
//
//  Created by Fabian Canas on 1/17/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

//MARK: Sub-Types

/// The type of text entry for a TextEntryFormRow.
/// Determines the type of keyboard shown when the user is editing the row's value.
public enum TextEntryType: String {
    /// Specifies the default keyboard for the current input method.
    case Plain     = "Formulary.Plain"
    /// Specifies a numeric keypad designed for PIN entry. This keyboard type prominently features the numbers 0 through 9.
    case Number    = "Formulary.Number"
    /// Specifies a keyboard with numbers and a decimal point.
    case Decimal   = "Formulary.Decimal"
    /// Specifies a keyboard optimized for entering email addresses. This keyboard type prominently features the at (“@”), period (“.”) and space characters.
    case Email     = "Formulary.Email"
    /// Specifies a keyboard optimized for Twitter text entry, with easy access to the at (“@”) and hash (“#”) characters.
    case Twitter   = "Formulary.Twitter"
    /// Specifies a keyboard optimized for URL entry. This keyboard type prominently features the period (“.”) and slash (“/”) characters and the “.com” string.
    case URL       = "Formulary.URL"
    /// Specifies a keyboard optimized for web search terms and URL entry. This keyboard type prominently features the space and period (“.”) characters.
    case WebSearch = "Formulary.WebSearch"
    /// Specifies a keypad designed for entering telephone numbers. This keyboard type prominently features the numbers 0 through 9 and the “*” and “#” characters.
    case Phone     = "Formulary.Phone"
    /// Specifies a keypad designed for entering a person’s name or phone number.
    case NamePhone = "Formulary.PhoneName"
}

private let KeyMap :[TextEntryType : UIKeyboardType] = [
    TextEntryType.Plain     : UIKeyboardType.default,
    TextEntryType.Number    : UIKeyboardType.numberPad,
    TextEntryType.Decimal   : UIKeyboardType.decimalPad,
    TextEntryType.Email     : UIKeyboardType.emailAddress,
    TextEntryType.Twitter   : UIKeyboardType.twitter,
    TextEntryType.URL       : UIKeyboardType.URL,
    TextEntryType.WebSearch : UIKeyboardType.webSearch,
    TextEntryType.Phone     : UIKeyboardType.phonePad,
    TextEntryType.NamePhone : UIKeyboardType.namePhonePad,
]

//MARK: Form Row

/**
 * TextEntryFormRow is a type of FormRow that allows for arbitrary text and 
 * number entry in Formulary.
 *
 * To use a TextEntryFormRow, it is only necessary to create one, add it to a
 * FormSection, and add that FormSection to a Form.
 *
 * `TextEntryFormRow` serves as a good example to anyone wishing to extend
 * Formulary's capabilities without altering Formulary itself. 
 * `TextEntryFormRow` interacts with Formulary entirely through public APIs.
 *
 * - seealso: `FormRow`
 */
open class TextEntryFormRow : FormRow, FormularyComponent {
    private static var __once: () = { () -> Void in
            registerFormularyComponent(TextEntryFormRow.self)
        }()
    /** 
     * The type of text entry the form row supports
     *
     * - seealso: `TextEntryType`
     */
    open let textType: TextEntryType
    
    /**
     * An NSFormatter that transforms the text in the form row as the user types
     * into it.
     */
    open let formatter: Formatter?
    
    /**
     * A cell reuse udentifier used by Formulary.
     * It generally corresponds to the type of cell and the type of input it is
     * capable of receiving.
     */
    override open var cellIdentifier :String {
        get {
            return textType.rawValue
        }
    }
    
    static var registrationToken :Int = 0
    
    /**
     * Returns an initialized text entry form row with the specified parameters.
     */
    public init(name: String, tag: String? = nil, textType: TextEntryType = .Plain, value: AnyObject? = nil, validation: @escaping Validation = PermissiveValidation, formatter: Formatter? = nil, action: Action? = nil) {
        
        _ = TextEntryFormRow.__once
        
        self.textType = textType
        self.formatter = formatter
        super.init(name: name, tag: tag, type: .Specialized, value: value, validation: validation, action: action)
    }
    
    /**
     * A function returning a map of Row type to cell class required to register
     * as a `FormularyComponent`. This tells Formulary how to show a 
     * `TextEntryFormRow` within a Form.
     */
    open static func cellRegistration() -> [String : AnyClass] {
        return [
            TextEntryType.Plain.rawValue : TextEntryCell.self,
            TextEntryType.Number.rawValue : TextEntryCell.self,
            TextEntryType.Decimal.rawValue : TextEntryCell.self,
            TextEntryType.Email.rawValue : TextEntryCell.self,
            TextEntryType.Twitter.rawValue : TextEntryCell.self,
            TextEntryType.URL.rawValue : TextEntryCell.self,
            TextEntryType.WebSearch.rawValue : TextEntryCell.self,
            TextEntryType.Phone.rawValue : TextEntryCell.self,
            TextEntryType.NamePhone.rawValue : TextEntryCell.self,
        ]
    }
}

//MARK: Cell

class TextEntryCell: UITableViewCell, FormTableViewCell {
    
    var configured: Bool = false
    var action :Action?
    
    var textField :NamedTextField?
    var formatterAdapter : FormatterAdapter?
    
    var formRow :FormRow? {
        didSet {
            if var formRow = formRow as? TextEntryFormRow {
                configureTextField(&formRow).keyboardType = KeyMap[formRow.textType]!
            }
            selectionStyle = .none
        }
    }
    
    func configureTextField(_ row: inout TextEntryFormRow) -> UITextField {
        if (textField == nil) {
            let newTextField = NamedTextField(frame: contentView.bounds)
            newTextField.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(newTextField)
            textField = newTextField
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[textField]-|", options: [], metrics: nil, views: ["textField":newTextField]))
            contentView.addConstraints([NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 60.0)])
            textField = newTextField
        }
        formatterAdapter = row.formatter.map { FormatterAdapter(formatter: $0) }
        
        textField?.text = row.value as? String
        textField?.placeholder = row.name
        textField?.validation = row.validation
        textField?.delegate = formatterAdapter
        textField?.isEnabled = row.enabled
        
        if let field = textField {
            let events :UIControlEvents = [.valueChanged, .editingChanged, .editingDidEnd, .editingDidEndOnExit]
            clear(field, controlEvents: events)
            bind(field, controlEvents: events, action: { [row] _ in row.value = field.text as AnyObject? })
        }
        
        configured = true
        return textField!
    }
}
