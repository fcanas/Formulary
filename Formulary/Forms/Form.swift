//
//  Form.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

// MARK: Protocols

public typealias Action = (AnyObject?) -> Void

/**
 * A Form represents both a schema and data for a user-facing form.
 *
 * The structure and properties of a `Form` and its children constitue the 
 * schema and determine how a `Form` should appear to a user. Children of the 
 * form may then be populated with data, either programmaticaly or by the user.
 *
 * A `Form`, while central to Formulary, is a simple wrapper around one level of
 * children, each of which must be a FormSection.
 *
 * A Form is not directly a user-interface element, and so cannot be put into
 * a view or view controller hierarchy directly. Use a FormViewController to 
 * display a Form to a user.
 *
 * - seealso: FormSection, FormViewController
 */
open class Form {
    /**
     * An array of `FormSection`s that belong to the `Form`
     */
    open let sections: [FormSection]
    
    internal var editingEnabled :Bool = true {
        didSet {
            for section in self.sections {
                section.editingEnabled = editingEnabled
            }
        }
    }
    
    /**
     * Creates a Form from provided `FormSection`s
     */
    public init(sections: [FormSection]) {
        self.sections = sections
    }
}

/**
 * A FormSection is a collection of `FormRow`s
 */
open class FormSection {
    /// The rows that constitute the FormSection
    open var rows: [FormRow]
    
    /**
     * The display name of the `FormSection`.
     *
     * Used to label table view section headers when presented in a 
     * `UITableView` via `FormViewController`.
     */
    var name: String?
    
    /**
     * The footer string.
     *
     * Used to label table view section footers when presented in a
     * `UITableView` via `FormViewController`.
     */
    var footerName: String?
    
    fileprivate var editingEnabled :Bool = true {
        didSet {
            for row in self.rows {
                row.enabled = editingEnabled
            }
        }
    }
    
    /**
     * Subclasses of `FormSection` protocol may provide an explicit value
     * function via `valueOverride. Otherwise, a section's value as determined
     * by `value(section:)` is the `Dictionary` of all the `FormSection`'s 
     * `FormRow`'s values.
     */
    open var valueOverride: ((Void) -> [String: AnyObject])?
    
    /**
     * Creates a FormSection
     *
     * - parameters:
     *   - rows And array of FormRows that constitute the FormSection
     *   - name An optional name for the FormSection. Defaults to `nil`
     *   - footerName An optional footerName for the FormSection. Defaults to `nil`
     *   - valueOverride An optional function to serve as a value adapter for the FormSection. Defaults to `nil`
     */
    public init(rows: [FormRow], name: String? = nil, footerName: String? = nil, valueOverride: ((Void) -> [String: AnyObject])? = nil) {
        self.rows = rows
        self.name = name
        self.footerName = footerName
        self.valueOverride = valueOverride
    }
}

/** 
 * When extending Formulary with new component types, you may need to register
 * with Formulary to access certain extension points.
 */
public protocol FormularyComponent :class {
    /// Associate a reuse identifier with a UITableViewCell class
    static func cellRegistration() -> [String : AnyClass]
}

/**
 * Register an external `FormularyComponent` with Formulary.
 *
 * If you choose to extend Formulary with custom components, you must register
 * those components at run time with this function before attempting to 
 * instantiate a `FormViewController` with a `Form` that uses those custom 
 * components.
 */
public func registerFormularyComponent<T :FormularyComponent>(_ component :T.Type) {
    for (id, cellClass) in component.cellRegistration() {
        FormDataSource.registerClass(cellClass, forCellReuseIdentifier: id)
    }
}

/**
 * Represents a single Row in a form.
 */
open class FormRow {
    /// The name of the FormRow
    var name: String
    
    /**
     * The tag of the FormRow.
     *
     * When a Form's value is extracted as a [String : AnyObject] of key-value 
     * pairs, a row's tag serves as the key. Where row names do not have to be
     * unique within a Form, row tags should be.
     *
     * If a tag is not provided at creation time, the name is used as a tag. No
     * effort is made by Formulary to ensure automatic tags are unique. You may
     * experience unexpected behavior if tags are not unique.
     */
    var tag: String
    
    /// The Type of FormRow, roughly corresponding to the type of data the row represents
    var type: FormRowType
    
    /**
     * Subclasses with custom cells should override `cellIdentifier` and
     * register a cell class and reuse identifier by defining a 
     * `FormularyComponent` and registering via `registerFormularyComponent`.
     *
     * - seealso: `registerFormularyComponent`, `FormularyComponent`
     */
    open var cellIdentifier: String {
        get {
            return type.rawValue
        }
    }
    
    /**
     * The computed value of the FormRow. Typically this will be set 
     * programatically for a pre-populated form, or derived from user input.
     *
     * Different types of FormRows may generate values of different types.
     */
    open var value: AnyObject?
    
    /**
     * An Action to be assiciated with the FormRow.
     */
    var action: Action?
    
    /**
     * A validation to associate with a FormRow.
     */
    var validation: Validation
    
    var enabled: Bool = true
    
    /**
     * Construct a FormRow
     */
    public init(name: String, tag: String? = nil, type: FormRowType, value :AnyObject?, validation :@escaping Validation = PermissiveValidation, action :Action? = nil) {
        self.name = name
        self.tag = tag ?? name
        self.type = type
        self.value = value
        self.validation = validation
        self.action = action
    }
}

// MARK: Rows

func rowForIndexPath(_ indexPath: IndexPath, form: Form) -> FormRow {
    return form.sections[indexPath.section].rows[indexPath.row]
}

func allRows(_ form: Form) -> [FormRow] {
    return form.sections.reduce(Array<FormRow>(), { (rows, section) -> Array<FormRow> in
        return rows + section.rows
    })
}

// MARK: Validation

/**
 * Performs all validations on a `Form` and returns `true` if they all pass.
 *
 * - parameters:
 *   - form: the `Form` to validate
 * - returns: `true` if all of `form`'s sections are valid.
 * - seealso: `isValid(section:)`
 */
public func valid(_ form: Form) -> Bool {
    return form.sections.reduce(true, { valid, section in
        valid && isValid(section)
    })
}

/**
 * Performs all validations on a `FormSection` and returns `true` if they all 
 * pass.
 *
 * - parameters:
 *   - section: the `FormSection` to validate
 * - returns: `true` if all of `sections`'s rows are valid.
 * - seealso: `valid(form:)`, `isValid(row:)`
 */
public func isValid(_ section: FormSection) -> Bool {
    return section.rows.reduce(true, { valid, row in
        return (valid && isValid(row))
    })
}

/**
 * Performs validation on a `FormRow` and returns `true` if they pass.
 *
 * - parameters:
 *   - section: The `FormRow` to validate
 * - returns: `true` if `row`'s value is valid
 * - seealso: `valid(form:)`, `isValid(section:)`
 */
public func isValid(_ row: FormRow) -> Bool {
    return row.validation(row.value as? String).valid
}

// MARK: Values

/** 
 * Returns the Key-Value Pairs of the data representing the Form
 */
public func values(_ form: Form) -> [String: AnyObject] {
    return form.sections.reduce(Dictionary<String, AnyObject>(), {(vs, section) in
        var mvs = vs
        for (k, v) in values(section) { mvs[k] = v }
        return mvs
    })
}

/**
 * Returns the Key-Value Pairs of the data representing the FormSection
 */
func values(_ section: FormSection) -> [String: AnyObject] {
    if let v = section.valueOverride {
        return v()
    }
    
    return section.rows.reduce(Dictionary<String, AnyObject>(), {(vs, row) in
        var mvs = vs
        if let v: AnyObject = row.value {
            mvs[row.tag] = v
        }
        return mvs
    })
}
