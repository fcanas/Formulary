//
//  Form.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

// MARK: Protocols

public typealias ActionClosure = (AnyObject?) -> Void

public protocol Form {
    var sections: [FormSection] { get }
}

public protocol FormSection {
    var name: String? { get }
    var rows: [FormRow] { get }
    var footerName: String? { get set }
    
    /// Implementers of the FormSection protocol may provide an explicit value
    /// function. Otherwise, a section's value as determined by `value(section:)`
    /// is the Dictionary of all the section's row's values.
    var valueOverride: ((Void) -> [String: AnyObject])? { get }
}

public protocol FormRow {
    var name: String { get }
    var type: FormRowType { get }
    
    var tag: String { get set }
    var value: AnyObject? { get set }
    
    var action: ActionClosure? { get set }
    
    var validation: Validation { get set }
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

func identifier(row: FormRow) -> String {
    return row.type.rawValue
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
    return form.sections.reduce(Dictionary<String, AnyObject>(), combine: {vs, section in
        var mvs = vs
        for (k, v) in values(section) {
            mvs[k] = v
        }
        return mvs
    })
}

func values(section: FormSection) -> [String: AnyObject] {
    if let v = section.valueOverride {
        return v()
    }
    
    return section.rows.reduce(Dictionary<String, AnyObject>(), combine: {vs, row in
        var mvs = vs
        if let v: AnyObject = row.value {
            mvs[row.tag] = v
        }
        return mvs
    })
}
