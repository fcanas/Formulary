//
//  Form.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

public struct Form {
    public let sections: [FormSection]
    public init(sections: [FormSection]) {
        self.sections = sections
    }
}

public struct FormSection {
    public let name: String
    public let rows: [FormRow]
    public init(name: String, rows: [FormRow]) {
        self.name = name
        self.rows = rows
    }
}

public struct FormRow {
    public let name: String
    public init(name: String) {
        self.name = name
    }
}
