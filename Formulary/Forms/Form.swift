//
//  Form.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

public enum FormRowType: String {
    case Plain  = "Plain"
    case Switch = "Switch"
    case Text   = "Text"
}

// MARK: Protocols

public protocol Form {
    var sections: [FormSection] { get }
}

public protocol FormSection {
    var name: String? { get }
    var rows: [FormRow] { get }
    var footerName: String? { get set }
}

public protocol FormRow {
    var name: String { get }
    var type: FormRowType { get }
    
    var tag: String { get set }
    var value: AnyObject? { get set }
    
    func identifier() -> String
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

// MARK: Values

func values(form: Form) -> [String: AnyObject] {
    return form.sections.reduce(Dictionary<String, AnyObject>(), combine: {vs, section in
        var mvs = vs
        for (k, v) in values(section) {
            mvs[k] = v
        }
        return mvs
    })
}

func values(section: FormSection) -> [String: AnyObject] {
    return section.rows.reduce(Dictionary<String, AnyObject>(), combine: {vs, row in
        var mvs = vs
        if let v: AnyObject = row.value {
            mvs[row.tag] = v
        }
        return mvs
    })
}
