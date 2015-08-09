//
//  Validation.swift
//  Formulary
//
//  Created by Fabian Canas on 1/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

public typealias Validation = (String?) -> (valid: Bool, reason: String)

public let PermissiveValidation: Validation = { _ in (true, "")}

public let RequiredString: (String) -> Validation = { name in
    { value in
        
        if value == nil {
            return (false, "\(name) can't be empty")
        }
        
        if let text = value {
            if text.isEmpty {
                return (false, "\(name) can't be empty")
            }
            
            return (true, "")
        }
        
        return (false, "\(name) must be a String")
    }
}

private extension String {
    func toDouble() -> Double? {
        let trimmedValue = (self as NSString).stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        return self == trimmedValue ? (self as NSString).doubleValue : nil
    }
}
public let MinimumNumber: (String, Int) -> Validation = { name, min in
    { value in
        
        if let value = value {
            if let number = value.toDouble() {
                if number < Double(min) {
                    return (false, "\(name) must be at least \(min)")
                }
                
                return (true, "")
            }
        } else {
            return (false, "\(name) must be at least \(min)")
        }
        
        return (false, "\(name) must be a number")
    }
}

public let MaximumNumber: (String, Int) -> Validation = { name, max in
    { value in
        
        if let value = value {
            if let number = value.toDouble() {
                if number > Double(max) {
                    return (false, "\(name) must be at most \(max)")
                }
                
                return (true, "")
            }
        } else {
            return (false, "\(name) must be at most \(max)")
        }
        
        return (false, "\(name) must be a number")
    }
}

public func && (lhs: Validation, rhs: Validation) -> Validation {
    return { value in
        let lhsr = lhs(value)
        if !lhsr.valid {
            return lhsr
        }
        
        let rhsr = rhs(value)
        if !rhsr.valid {
            return rhsr
        }
        
        return (true, "")
    }
}
