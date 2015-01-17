//
//  NamedTextField.swift
//  Formulary
//
//  Created by Fabian Canas on 1/17/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

class NamedTextField: UITextField {
    
    let nameLabel = UILabel()
    
    var nameFont :UIFont = UIFont.systemFontOfSize(12) {
        didSet {
            nameLabel.font = nameFont
        }
    }
    
    var topMargin :CGFloat = 4
    
    override var placeholder :String? {
        didSet {
            nameLabel.text = placeholder
            nameLabel.sizeToFit()
        }
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if text.isEmpty {
            hideNameLabel(isFirstResponder())
        } else {
            showNameLabel(isFirstResponder())
        }
    }
    
    private func showNameLabel(animated: Bool) {
        UIView.animateWithDuration(animated ? 0.25 : 0, animations: { () -> Void in
            var f = self.nameLabel.frame
            f.origin.y = 3
            self.nameLabel.frame = f
            self.nameLabel.alpha = 1.0
        })
    }
    
    private func hideNameLabel(animated: Bool) {
        UIView.animateWithDuration(animated ? 0.25 : 0, animations: { () -> Void in
            var f = self.nameLabel.frame
            f.origin.y = self.nameLabel.font.lineHeight
            self.nameLabel.frame = f
            self.nameLabel.alpha = 0.0
        })
    }
    
    override func textRectForBounds(bounds:CGRect) -> CGRect {
        var r = super.textRectForBounds(bounds)
        var top = ceil(nameLabel.font.lineHeight)
        r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top + topMargin, 0.0, 0.0, 0.0))
        return CGRectIntegral(r)
    }
    
    override func editingRectForBounds(bounds:CGRect) -> CGRect {
        var r = super.editingRectForBounds(bounds)
        var top = ceil(nameLabel.font.lineHeight)
        r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top + topMargin, 0.0, 0.0, 0.0))
        return CGRectIntegral(r)
    }
    
    // MARK: Appearance
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        nameLabel.textColor = tintColor
    }
    
    // MARK: Initialize
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    private func sharedInit() {
        nameLabel.alpha = 0
        nameLabel.textColor = tintColor
        nameLabel.font = nameFont
        addSubview(nameLabel)
    }
    
}
