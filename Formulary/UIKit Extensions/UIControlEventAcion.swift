//
//  UIControlEventAction.swift
//  Formulary
//
//  Created by Fabian Canas on 8/9/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

private let ActionTargetControlKey :UnsafePointer<Void> = UnsafePointer<Void>()

func bind(control: UIControl, controlEvents: UIControlEvents = .ValueChanged, action: (UIControl) -> Void) {
    let actionTarget = ActionTarget(control: control, action: action, controlEvents: controlEvents)
    objc_setAssociatedObject(control, ActionTargetControlKey, actionTarget, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

func clear(control :UIControl, controlEvents :UIControlEvents) {
    if let target = objc_getAssociatedObject(control, ActionTargetControlKey) as? ActionTarget {
        control.removeTarget(target, action: Selector("action:"), forControlEvents: controlEvents)
        objc_setAssociatedObject(control, ActionTargetControlKey, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

/// Allows attaching a closure to a UIControlEvent on a UIControl
private class ActionTarget {
    let control: UIControl
    let closure: (UIControl) -> Void
    init(control: UIControl, action: (UIControl) -> Void, controlEvents: UIControlEvents) {
        self.control = control
        closure = action
        control.addTarget(self, action: Selector("action:"), forControlEvents: controlEvents)
    }
    
    @objc func action(sender: UIControl) {
        closure(sender)
    }
}
