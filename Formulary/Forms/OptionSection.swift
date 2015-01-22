//
//  OptionSection.swift
//  Formulary
//
//  Created by Fabian Canas on 1/22/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

public struct OptionSection: FormSection {
    public let name: String?
    public let rows: [FormRow]
    public var footerName: String?
    
    public let singleSelect: Bool
    
    public var valueOverride: ((Void) -> [String: AnyObject])?
    
    public init(rowValues: [String], name: String? = nil, footerName :String? = nil, singleSelect: Bool = true) {
        self.name = name
        
        self.rows = rowValues.map({ value  in
            return ConcreteFormRow(name: value, tag: value, value: false, type: .Toggle)
        })
        self.footerName = footerName
        self.singleSelect = singleSelect
        
        
        let r = self.rows.filter({ row in
            return (row.value as? Bool) ?? false
        }).reduce(Array<String>(), combine: {values, row in
            var v = values
            v.append(row.name)
            return v
        })
        
        let allValues: ()->[String] = {
            let r = self.rows.filter({ row in
                return (row.value as? Bool) ?? false
            }).reduce([String](), combine: {vs, row in
                var v = vs
                v.append(row.name)
                return v
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
        
    }
}
