//
//  OptionSection.swift
//  Formulary
//
//  Created by Fabian Canas on 1/22/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

public class OptionSection: FormSection {
    public let name: String?
    public var rows: [FormRow]
    public var footerName: String?
    
    public let singleSelect: Bool
    
    public var valueOverride: ((Void) -> [String: AnyObject])?
    
    public init(rowValues: [String], name: String? = nil, footerName :String? = nil, singleSelect: Bool = true, value: Any? = nil) {
        self.name = name
        
        self.footerName = footerName
        self.singleSelect = singleSelect
        
        rows = rowValues.map({ value  in
            let row = ConcreteFormRow(name: value, tag: value, value: false, type: .Toggle)
            return row
        })
        
        //        let r = self.rows.filter({ row in
        //            return (row.value as? Bool) ?? false
        //        }).reduce(Array<String>(), combine: {values, row in
        //            var v = values
        //            v.append(row.name)
        //            return v
        //        })
        //
        let allValues: ()->[String] = {
            let r = self.rows.filter({ row in
                return (row.value as? Bool) ?? false
            }).reduce([String](), combine: {(var vs, row) in
                vs.append(row.name)
                return vs
            })
            
            return r
        }
        
        if singleSelect {
            valueOverride = {
                let singleValue = allValues().first
                if singleValue != nil {
                    return [self.name! : singleValue!]
                } else {
                    return Dictionary<String,String>()
                }
            }
        } else {
            valueOverride = {
                return [self.name! : allValues()]
            }
        }
        
        for rowX in rows {
            if var row = rowX as? ConcreteFormRow {
                row.action = { _ in
                    self.triggerRow(row)
                }
            }
        }
    }
    
    func triggerRow(row: ConcreteFormRow) {
        let v = row.value as? Bool ?? false
        row.value = !v
    }
    
    func deselectAll() {
        for row in rows {
            if var r = row as? ConcreteFormRow {
                r.value = false
            }
        }
    }
    
    func deselectAllBut(selectedRow: ConcreteFormRow) {
        for rowX in rows {
            if var row = rowX as? ConcreteFormRow {
//                if row.name != selectedRow.name {
                    row.value = false
                row.action?(row.value)
//                let rowName = row.name ?? "hi"
                println("deselecting \(row)")
//                }
            }
            
        }
        selectedRow.value = true
    }
}

private class SelectableRow : ConcreteFormRow {
    func deselect() {
        value = false
    }
    
    var cell :UITableViewCell?
    
//    public let name: String
//    public let type: FormRowType
//
//    public var tag: String
//    public var value: AnyObject?
//
//    public var action: ((AnyObject?) -> Void)?
//
//    public var validation: Validation
//
//    public init(name: String, tag: String! = nil, value: AnyObject? = nil, type: FormRowType = .Plain, validation: Validation = PermissiveValidation, action: ActionClosure? = nil) {
//        self.name = name
//        self.type = type
//        self.value = value
//        self.tag = tag ?? name
//        self.validation = validation
//        self.action = action
//    }
}
