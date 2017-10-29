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
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        let decimalFormatter = NumberFormatter()
        decimalFormatter.maximumFractionDigits = 5
        
        let integerFormatter = NumberFormatter()
        
        self.form = Form(sections: [
            FormSection(rows: [
                TextEntryFormRow(name:"Name", tag: "name", validation: RequiredString("Name")),
                TextEntryFormRow(name: "Email", tag: "email", textType: TextEntryType.Email),
                TextEntryFormRow(name:"Age", tag: "age", textType: TextEntryType.Number, validation: MinimumNumber("Age", 13), formatter: integerFormatter)],
                name:"Profile"),
            FormSection(rows: [
                TextEntryFormRow(name:"Favorite Number", tag: "favoriteNumber", textType: .Decimal, value: nil, validation: MinimumNumber("Your favorite number", 47) && MaximumNumber("Your favorite number", 47), formatter: decimalFormatter),
                FormRow(name:"Do you like goats?", tag: "likesGoats", type: .Switch, value: false as AnyObject?),
                TextEntryFormRow(name:"Other Thoughts?", tag: "thoughts", textType: .Plain),],
                name:"Preferences",
                footerName: "Fin"),
            OptionSection(rowValues:["Ice Cream", "Pizza", "Beer"], name: "Food", value: ["Pizza", "Ice Cream"]),
            FormSection(rows: [PickerFormRow(name: "House", options: ["Gryffindor", "Ravenclaw", "Slytherin", "Hufflepuff"])], name: "House"),
            FormSection(rows: [
                FormRow(name:"Show Values", tag: "show", type: .Button, value: nil, action: { _ in
                    
                    let data = try! JSONSerialization.data(withJSONObject: values(self.form), options: [])
                    let s = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    
                    let alert = UIAlertController(title: "Form Values", message: s as String?, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                })
            ]),
        ])
        setEditing(true, animated: false)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editingEnabled = editing
    }
}

