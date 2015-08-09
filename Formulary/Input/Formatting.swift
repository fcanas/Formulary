//
//  Formatting.swift
//  Formulary
//
//  Created by Fabian Canas on 8/9/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

class FormatterAdapter :NSObject, UITextFieldDelegate {
    let formatter :NSFormatter
    
    required init(formatter: NSFormatter) {
        self.formatter = formatter
        super.init()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        if newString == "" {
            return true
        }
        var obj :AnyObject?
        formatter.getObjectValue(&obj, forString: newString, errorDescription: nil)
        if let obj :AnyObject = obj {
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        var obj :AnyObject?
        formatter.getObjectValue(&obj, forString: textField.text, errorDescription: nil)
        if let obj :AnyObject = obj {
            textField.text = formatter.stringForObjectValue(obj)
        }
    }
}
