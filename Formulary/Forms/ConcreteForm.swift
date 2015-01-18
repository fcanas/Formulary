//
//  ConcreteForm.swift
//  Formulary
//
//  Created by Fabian Canas on 1/17/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

// MARK: Form

public struct ConcreteForm: Form {
    public let sections: [FormSection]
    public init(sections: [FormSection]) {
        self.sections = sections
    }
}

// MARK: Section

public struct ConcreteFormSection: FormSection {
    public let name: String?
    public let rows: [FormRow]
    public var footerName: String?
    
    public init(rows: [FormRow], name: String? = nil, footerName :String? = nil) {
        self.name = name
        self.rows = rows
        self.footerName = footerName
    }
}

// MARK: Row

public class ConcreteFormRow : FormRow {
    public let name: String
    public let type: FormRowType
    
    public var tag: String
    public var value: AnyObject?
    
    public var action: ((AnyObject?) -> Void)?
    
    public init(name: String, tag: String! = nil, value: AnyObject? = nil, type: FormRowType = .Plain, action: ActionClosure? = nil) {
        self.name = name
        self.type = type
        self.value = value
        self.tag = tag ?? name
        self.action = action
    }
    
    public func identifier() -> String {
        return "RowIdentifier"
    }
}
