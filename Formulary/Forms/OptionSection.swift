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
    
    public var valueOverride: ((Void) -> [String: AnyObject])?
    
    public init(rowValues: [String], name: String? = nil, footerName :String? = nil, value: Any? = nil) {
        self.name = name
        
        self.footerName = footerName
        
        rows = rowValues.map({ value  in
            let row = ConcreteFormRow(name: value, tag: value, value: false, type: .Toggle)
            return row
        })
        
        let allValues: ()->[String] = {
            let r = self.rows.filter({ row in
                return (row.value as? Bool) ?? false
            }).reduce([String](), combine: {(var vs, row) in
                vs.append(row.name)
                return vs
            })
            
            return r
        }
        
        valueOverride = {
            return [self.name! : allValues()]
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
                row.value = false
                row.action?(row.value)
                println("deselecting \(row)")
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
}
