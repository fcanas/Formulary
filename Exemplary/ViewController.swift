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
        self.form = Form(sections: [
            FormSection(rows: [
                TextEntryFormRow(name:"Name", tag: "name", validation: RequiredString("Name")),
                TextEntryFormRow(name: "Email", tag: "email", textType: TextEntryType.Email),
                TextEntryFormRow(name:"Age", tag: "age", textType: TextEntryType.Number, validation: MinimumNumber("Age", 13))],
                name:"Profile"),
            FormSection(rows: [
                TextEntryFormRow(name:"Favorite Number", tag: "favoriteNumber", value: nil, textType: .Decimal, validation: MinimumNumber("Your favorite number", 47) && MaximumNumber("Your favorite number", 47), formatter: NSNumberFormatter()),
                FormRow(name:"Do you like goats?", tag: "likesGoats", type: .Switch, value: false),
                TextEntryFormRow(name:"Other Thoughts?", tag: "thoughts", textType: .Plain),],
                name:"Preferences",
                footerName: "Fin"),
            OptionSection(rowValues:["Ice Cream", "Pizza", "Beer"], name: "Food", value: ["Pizza", "Ice Cream"]),
            FormSection(rows: [
                FormRow(name:"Show Values", tag: "show", type: .Button, value: nil, action: { _ in
                    
                    let data = NSJSONSerialization.dataWithJSONObject(values(self.form), options: nil, error: nil)!
                    let s = NSString(data: data, encoding: NSUTF8StringEncoding)
                    
                    let alert = UIAlertController(title: "Form Values", message: s as? String, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            ])
        ])
    }
}

