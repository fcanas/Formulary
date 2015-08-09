//
//  Formatting.swift
//  Formulary
//
//  Created by Fabian Canas on 8/9/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import Foundation

let FormattingAdapterKey :UnsafePointer<Void> = UnsafePointer<Void>()

public extension UITextField {
    public func setFormatter(formatter: NSFormatter?) {
        if let formatter = formatter {
            let adapter = FormatterAdapter(formatter: formatter)
            objc_setAssociatedObject(self, FormattingAdapterKey, adapter, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            delegate = adapter
        } else {
            objc_setAssociatedObject(self, FormattingAdapterKey, nil, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
}

private class FormatterAdapter :NSObject, UITextFieldDelegate {
    let formatter :NSFormatter?
    
    required init(formatter: NSFormatter) {
        self.formatter = formatter
        super.init()
    }
    
    private func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let formatter = formatter {
            let newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            textField.text = formatter.stringForObjectValue(newString)
            return false
        }
        
        return true
    }
}
