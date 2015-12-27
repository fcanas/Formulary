//
//  Validation.swift
//  Formulary
//
//  Created by Fabian Canas on 1/21/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

/**
 * A Validation is a function used to assert something about a `String?`
 *
 * Validtions are used by Formulary to assert something about the value of a 
 * FormRow. A FormRow can usually represent its `value` as a `String`. And so a
 * Validation associated with a FormRow will be given the FormRow value as a 
 * String, and use the resulting `(valid: Bool, reason: String)` to signal
 * validity and reason for failure.
 *
 * - parameters:
 *   - String: an input, such as a `value` from a `FormRow`
 * - returns: ( `valid:` whether the value parameter is valid according to the Validation, `reason:` A user-visible explanation of a failure)
 */
public typealias Validation = (String?) -> (valid: Bool, reason: String)

/// A Validation that always succeeds regardless of input.
public let PermissiveValidation: Validation = { _ in (true, "")}

/// A Validation that passes iff its input is a String and not empty _i.e._ `""`
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

/**
* Generate a Validation asserting its input is greater than the provided minimum.
*
* - parameters:
*   - reason: The name of the parameter. Gets incorporated into the failure message.
*   - maximum: The threshold number. Inputs to the resulting Validation above this value will fail.
* - returns: A Validation function asserting that its input values are above a minimum value
* - seealso: Validation
*/
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

/**
 * Generate a Validation asserting its input is less than the provided maximum.
 *
 * - parameters:
 *   - reason: The name of the parameter. Gets incorporated into the failure message.
 *   - maximum: The threshold number. Inputs to the Validation below this value will fail.
 * - returns: A Validation function asserting that its input values are below a maximum value
 * - seealso: Validation
 */
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

/**
 * Logical AND of two Validations
 *
 * Combines two Validations into one Validation where both sub-validations must
 * succeed for the resultant Validation to succeed. In the case of a failure, 
 * only one error message is returned. The LHS error is favored when both could
 * be returned.
 *
 * - parameters:
 *   - lhs: the first Validation. When both fail, this Validation's message will be returned
 *   - rhs: the second Validation
 * - returns: A new Validation that validates iff both parameter Validations pass.
 */
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
