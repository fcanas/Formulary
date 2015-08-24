//
//  Form.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

// MARK: Protocols

public typealias Action = (AnyObject?) -> Void

public class Form {
    public let sections: [FormSection]
    
    public var editingEnabled :Bool = true {
        didSet {
            for section in self.sections {
                section.editingEnabled = editingEnabled
            }
        }
    }
    
    public init(sections: [FormSection]) {
        self.sections = sections
    }
}

public class FormSection {
    public var rows: [FormRow]
    
    var name: String?
    var footerName: String?
    
    public var editingEnabled :Bool = true {
        didSet {
            for row in self.rows {
                row.enabled = editingEnabled
            }
        }
    }
    
    /// Subclasses of FormSection protocol may provide an explicit value
    /// function via `valueOverride. Otherwise, a section's value as determined
    /// by `value(section:)` is the Dictionary of all the section's row's values.
    var valueOverride: ((Void) -> [String: AnyObject])?
    
    public init(rows: [FormRow], name: String? = nil, footerName: String? = nil, valueOverride: ((Void) -> [String: AnyObject])? = nil) {
        self.rows = rows
        self.name = name
        self.footerName = footerName
        self.valueOverride = valueOverride
    }
}

/** When extending Formulary with new component types, you may need to register
    with Formulary to access certain extension points.
*/
public protocol FormularyComponent :class {
    /// Associate a reuse identifier with a UITableViewCell class
    static func cellRegistration() -> [String : AnyClass]
}

public func registerFormularyComponent<T :FormularyComponent>(component :T.Type) {
    for (id, cellClass) in component.cellRegistration() {
        FormDataSource.registerClass(cellClass, forCellReuseIdentifier: id)
    }
}

public class FormRow {
    var name: String
    var tag: String
    
    var type: FormRowType
    
    /** Subclasses with custom cells should override `cellIdentifier` and
        register a cell class and reuse identifier by defining a `FormularyComponent`
        and registering via `registerFormularyComponent`.

        :See also: `registerFormularyComponent`, `FormularyComponent`
    */
    public var cellIdentifier: String {
        get {
            return type.rawValue
        }
    }
    
    public var value: AnyObject?
    
    var action: Action?
    
    var validation: Validation
    
    var enabled: Bool = true
    
    public init(name: String, tag: String, type: FormRowType, value :AnyObject?, validation :Validation = PermissiveValidation, action :Action? = nil) {
        self.name = name
        self.tag = tag ?? name
        self.type = type
        self.value = value
        self.validation = validation
        self.action = action
    }
}

// MARK: Rows

func rowForIndexPath(indexPath: NSIndexPath, form: Form) -> FormRow {
    return form.sections[indexPath.section].rows[indexPath.row]
}

func allRows(form: Form) -> [FormRow] {
    return form.sections.reduce(Array<FormRow>(), combine: { (rows, section) -> Array<FormRow> in
        return rows + section.rows
    })
}

// MARK: Validity

public func valid(form: Form) -> Bool {
    return form.sections.reduce(true, combine: { valid, section in
        valid && isValid(section)
    })
}

public func isValid(section: FormSection) -> Bool {
    return section.rows.reduce(true, combine: { valid, row in
        return (valid && isValid(row))
    })
}

public func isValid(row: FormRow) -> Bool {
    return row.validation(row.value as? String).valid
}

// MARK: Values

public func values(form: Form) -> [String: AnyObject] {
    return form.sections.reduce(Dictionary<String, AnyObject>(), combine: {(var vs, section) in
        for (k, v) in values(section) { vs[k] = v }
        return vs
    })
}

func values(section: FormSection) -> [String: AnyObject] {
    if let v = section.valueOverride {
        return v()
    }
    
    return section.rows.reduce(Dictionary<String, AnyObject>(), combine: {(var vs, row) in
        if let v: AnyObject = row.value { vs[row.tag] = v }
        return vs
    })
}
