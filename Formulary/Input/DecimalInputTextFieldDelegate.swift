//
//  DecimalInputTextFieldDelegate.swift
//  Formulary
//
//  Created by Timm Preetz on 8.8.2015.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation
import UIKit

class DecimalInputTextFieldDelegate : NSObject, UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let textWithNewCharacters: String = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)

        if textWithNewCharacters == "" {
            return true
        }
        
        return NSNumberFormatter().numberFromString(textWithNewCharacters)?.doubleValue != nil
    }
}