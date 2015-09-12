//
//  UIControlEventAction.swift
//  Formulary
//
//  Created by Fabian Canas on 8/9/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

private let ActionTargetControlKey :UnsafePointer<Void> = UnsafePointer<Void>()

/// Allows attaching a closure to a UIControlEvent on a UIControl
class ActionTarget {
    let control: UIControl
    let closure: (UIControl) -> Void
    init(control: UIControl, controlEvents: UIControlEvents = .ValueChanged, action: (UIControl) -> Void) {
        self.control = control
        closure = action
        control.addTarget(self, action: Selector("action:"), forControlEvents: controlEvents)
        
        objc_setAssociatedObject(control, ActionTargetControlKey, self, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc func action(sender: UIControl) {
        closure(sender)
    }
    
    class func clear(control :UIControl, controlEvents :UIControlEvents) {
        if let target = objc_getAssociatedObject(control, ActionTargetControlKey) as? ActionTarget {
            control.removeTarget(target, action: Selector("action:"), forControlEvents: controlEvents)
        }
    }
}
