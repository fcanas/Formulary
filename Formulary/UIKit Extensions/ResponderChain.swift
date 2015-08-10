//
//  ResponderChain.swift
//  Formulary
//
//  Created by Fabian Canas on 8/10/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

extension UIView {
    func firstResponder() -> UIView? {
        if isFirstResponder() {
            return self
        }
        for subview in (subviews as! [UIView]) {
            if let responder = subview.firstResponder() {
                return responder
            }
        }
        return nil
    }
    func containingCell() -> UITableViewCell? {
        if let c = self as? UITableViewCell {
            return c
        }
        return superview?.containingCell()
    }
}
