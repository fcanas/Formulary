//
//  Formatting.swift
//  Formulary
//
//  Created by Fabian Canas on 8/9/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

let FormattingAdapterKey :UnsafePointer<Void> = UnsafePointer<Void>()

class FormatterAdapter :NSObject, UITextFieldDelegate {
    let formatter :NSFormatter
    
    required init(formatter: NSFormatter) {
        self.formatter = formatter
        super.init()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        var obj :AnyObject?
        formatter.getObjectValue(&obj, forString: newString, errorDescription: nil)
        if let obj :AnyObject = obj {
            textField.text = formatter.stringForObjectValue(obj)
        }
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {}
    func textFieldDidEndEditing(textField: UITextField) {}
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool { return true }
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
}
