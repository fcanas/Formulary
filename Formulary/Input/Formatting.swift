//
//  Formatting.swift
//  Formulary
//
//  Created by Fabian Canas on 8/9/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

internal class FormatterAdapter :NSObject, UITextFieldDelegate {
    let formatter :Formatter
    
    required init(formatter: Formatter) {
        self.formatter = formatter
        super.init()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        if newString == "" {
            return true
        }
        var obj :AnyObject?
        formatter.getObjectValue(&obj, for: newString, errorDescription: nil)
        if let _ :AnyObject = obj {
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var obj :AnyObject?
        formatter.getObjectValue(&obj, for: textField.text ?? "", errorDescription: nil)
        if let obj :AnyObject = obj {
            textField.text = formatter.string(for: obj)
        }
    }
}
