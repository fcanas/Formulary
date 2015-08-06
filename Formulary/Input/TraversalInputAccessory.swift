//
//  TraversalInputAccessory.swift
//  Formulary
//
//  Created by Fabian Canas on 8/5/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

class TraversalInputAccessory: UIToolbar {
    var currentControl :UIControl?

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildSubviews()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildSubviews()
    }
    
    func buildSubviews() {
        self.frame = CGRect(x: 0, y: 0, width: 0, height: 44)

        let back = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem(rawValue: 101)!, target: self, action: Selector("back"))
        let smallSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        let forward = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem(rawValue: 102)!, target: self, action: Selector("forward"))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("done"))
        
        smallSpace.width = 30
        
        items = [back, smallSpace, forward, space, done];
    }
    
    func done() {
        
    }
    
    func back() {
        
    }
    
    func forward() {
        
    }
}
