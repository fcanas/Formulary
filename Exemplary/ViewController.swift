//
//  ViewController.swift
//  Exemplary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit
import Formulary

class ViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.form = ConcreteForm(sections: [ConcreteFormSection(rows: [ConcreteFormRow(name:"Name", tag: "name", type: .Text),
                                                                       ConcreteFormRow(name:"Email", tag: "email", type: .Text),
                                                                       ConcreteFormRow(name:"Age", tag: "age", type: .Number)],
                                                                name:"Profile"),
                                            ConcreteFormSection(rows: [ConcreteFormRow(name:"Favorite Number", tag: "favoriteNumber", value: nil, type: .Decimal),
                                                                       ConcreteFormRow(name:"Ice Cream?", tag: "wantsIceCream", value: false, type: .Switch),
                                                                       ConcreteFormRow(name:"Beer?", tag: "wantsBeer", value: true, type: .Switch)],
                                                                name:"Preferences",
                                                                footerName: "Fin"),
            ConcreteFormSection(rows: [ConcreteFormRow(name:"Show Values", tag: "show", type: .Button, action: { _ in
                
                let data = NSJSONSerialization.dataWithJSONObject(values(self.form) as NSDictionary, options: nil, error: nil)!
                let s = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                let alert = UIAlertController(title: "Form Values", message: s, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            })])])
    }
    
}

