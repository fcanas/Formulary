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
        self.form = Formulary.ConcreteForm(sections: [
            Formulary.ConcreteFormSection(rows: [
                Formulary.ConcreteFormRow(name:"Name", tag: "name", type: .Text, validation: RequiredString("Name")),
                Formulary.ConcreteFormRow(name:"Email", tag: "email", type: .Email),
                Formulary.ConcreteFormRow(name:"Age", tag: "age", type: .Number, validation: MinimumNumber("Age", 13))],
                name:"Profile"),
            Formulary.ConcreteFormSection(rows: [
                Formulary.ConcreteFormRow(name:"Favorite Number", tag: "favoriteNumber", value: nil, type: .Decimal, validation: MinimumNumber("Your favorite number", 47) && MaximumNumber("Your favorite number", 47)),
                Formulary.ConcreteFormRow(name:"Ice Cream?", tag: "wantsIceCream", value: false, type: .Switch),
                Formulary.ConcreteFormRow(name:"Beer?", tag: "wantsBeer", value: true, type: .Switch),
                Formulary.ConcreteFormRow(name:"Other Thoughts?", tag: "thoughts", type: .Text),],
                name:"Preferences",
                footerName: "Fin"),
            Formulary.ConcreteFormSection(rows: [
                Formulary.ConcreteFormRow(name:"Show Values", tag: "show", type: .Button, action: { _ in
                    
                    let data = NSJSONSerialization.dataWithJSONObject(values(self.form) as NSDictionary, options: nil, error: nil)!
                    let s = NSString(data: data, encoding: NSUTF8StringEncoding)
                    
                    let alert = UIAlertController(title: "Form Values", message: s, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                ])
            ]
        )
    }
}

