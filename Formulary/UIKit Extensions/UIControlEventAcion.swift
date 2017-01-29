//
//  UIControlEventAction.swift
//  Formulary
//
//  Created by Fabian Canas on 8/9/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

private var ActionTargetControlKey = 0

func bind(_ control: UIControl, controlEvents: UIControlEvents = .valueChanged, action: @escaping (UIControl) -> Void) {
    let actionTarget = ActionTarget(control: control, action: action, controlEvents: controlEvents)
    objc_setAssociatedObject(control, &ActionTargetControlKey, actionTarget, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

func clear(_ control :UIControl, controlEvents :UIControlEvents) {
    if let target = objc_getAssociatedObject(control, &ActionTargetControlKey) as? ActionTarget {
        control.removeTarget(target, action: #selector(ActionTarget.action(_:)), for: controlEvents)
        objc_setAssociatedObject(control, &ActionTargetControlKey, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

/// Allows attaching a closure to a UIControlEvent on a UIControl
private class ActionTarget {
    weak var control: UIControl?
    let closure: (UIControl) -> Void
    init(control: UIControl, action: @escaping (UIControl) -> Void, controlEvents: UIControlEvents) {
        self.control = control
        closure = action
        control.addTarget(self, action: #selector(ActionTarget.action(_:)), for: controlEvents)
    }
    
    @objc func action(_ sender: UIControl) {
        closure(sender)
    }
}
