//
//  Form.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

public enum FormRowType: String {
    case Plain = "Plain";
    case Switch = "Switch";
}

//func cellClassForType(type: FormRowType) -> 


//func cellBuilderForType(type: FormRowType) -> (FormRow) -> UITableViewCell {
//    switch type {
//    case .Plain:
//        return { row in
//            UITableViewCell()
//        }
//    case .Switch:
//        return { row in
//            let cell = UITableViewCell()
//            
//            return cell
//        }
//    }
//}

public struct Form {
    public let sections: [FormSection]
    public init(sections: [FormSection]) {
        self.sections = sections
    }
}

public struct FormSection {
    public let name: String?
    public let rows: [FormRow]
    public init(rows: [FormRow], name: String? = nil, footerName :String? = nil) {
        self.name = name
        self.rows = rows
        self.footerName = footerName
    }
    public var footerName: String?
}

public struct FormRow {
    public let name: String
    public let type: FormRowType
    public init(name: String, type: FormRowType = .Plain) {
        self.name = name
        self.type = type
    }
}
