//
//  OptionSection.swift
//  Formulary
//
//  Created by Fabian Canas on 1/22/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

/// A FormSection of items that can be selected among. 
/// Allows for multiple selection.
open class OptionSection: FormSection {
    
    /// Construct an OptionSection with an array of Strings for options
    public init(rowValues: [String], name: String? = nil, footerName :String? = nil, value: Any? = nil) {
        let rows = rowValues.map({ (value :String) -> FormRow in
            return FormRow(name: value, tag: value, type: .Toggle, value: false as AnyObject?)
        })
        
        let allValues: ()->[String] = {
            let r = rows.filter({ row in
                return (row.value as? Bool) ?? false
            }).reduce([String](), {(vs, row) in
                var v = vs
                v.append(row.name)
                return v
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
            return [self.name! : allValues() as AnyObject]
        } as (() -> [String : AnyObject])
    }
    
    func triggerRow(_ row: FormRow) {
        let v = row.value as? Bool ?? false
        row.value = !v as AnyObject?
    }
    
    func deselectAll() {
        for row in rows {
            row.value = false as AnyObject?
        }
    }
    
    func deselectAllBut(_ selectedRow: FormRow) {
        for row in rows {
            row.value = false as AnyObject?
            row.action?(row.value)
            print("deselecting \(row)")
        }
        selectedRow.value = true as AnyObject?
    }
}

private class SelectableRow : FormRow {
    func deselect() {
        value = false as AnyObject?
    }
    
    var cell :UITableViewCell?
}
