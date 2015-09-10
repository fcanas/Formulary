//
//  OptionSection.swift
//  Formulary
//
//  Created by Fabian Canas on 1/22/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

public class OptionSection: FormSection {
    
    public init(rowValues: [String], name: String? = nil, footerName :String? = nil, value: Any? = nil) {
        let rows = rowValues.map({ (value :String) -> FormRow in
            return FormRow(name: value, tag: value, type: .Toggle, value: false)
        })
        
        let allValues: ()->[String] = {
            let r = rows.filter({ row in
                return (row.value as? Bool) ?? false
            }).reduce([String](), combine: {(var vs, row) in
                vs.append(row.name)
                return vs
            })
            
            return r
        }
        
        super.init(rows: rows, name: name, footerName: footerName, valueOverride: nil)
        
        for row in rows {
            row.action = { _ in
                self.triggerRow(row)
            }
        }
        
        valueOverride = {
            return [self.name! : allValues()]
        }
    }
    
    func triggerRow(row: FormRow) {
        let v = row.value as? Bool ?? false
        row.value = !v
    }
    
    func deselectAll() {
        for row in rows {
            row.value = false
        }
    }
    
    func deselectAllBut(selectedRow: FormRow) {
        for row in rows {
            row.value = false
            row.action?(row.value)
            print("deselecting \(row)")
        }
        selectedRow.value = true
    }
}

private class SelectableRow : FormRow {
    func deselect() {
        value = false
    }
    
    var cell :UITableViewCell?
}
