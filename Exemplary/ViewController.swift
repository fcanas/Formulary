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
        
        registerFormularyComponent(TextEntryFormRow.self)
        registerFormularyComponent(NestedFormRow.self)
        
        navigationItem.rightBarButtonItem = editButtonItem()
        
        let decimalFormatter = NSNumberFormatter()
        decimalFormatter.maximumFractionDigits = 5
        
        let integerFormatter = NSNumberFormatter()
        
        self.form = Form(sections: [
            FormSection(rows: [
                TextEntryFormRow(name:"Name", tag: "name", validation: RequiredString("Name")),
                TextEntryFormRow(name: "Email", tag: "email", textType: TextEntryType.Email),
                TextEntryFormRow(name:"Age", tag: "age", textType: TextEntryType.Number, validation: MinimumNumber("Age", 13), formatter: integerFormatter)],
                name:"Profile"),
            FormSection(rows: [
                TextEntryFormRow(name:"Favorite Number", tag: "favoriteNumber", value: nil, textType: .Decimal, validation: MinimumNumber("Your favorite number", 47) && MaximumNumber("Your favorite number", 47), formatter: decimalFormatter),
                FormRow(name:"Do you like goats?", tag: "likesGoats", type: .Switch, value: false),
                TextEntryFormRow(name:"Other Thoughts?", tag: "thoughts", textType: .Plain),],
                name:"Preferences",
                footerName: "Fin"),
            OptionSection(rowValues:["Ice Cream", "Pizza", "Beer"], name: "Food", value: ["Pizza", "Ice Cream"]),
            FormSection(rows: [
                NestedFormRow(name: "First Goat", tag: "goat", nestedModel: Goat())
                ], name: "Goats"),
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
        setEditing(true, animated: false)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editingEnabled = editing
    }
}

class Goat {
    var name :String
    var weight :Int
    var color :String
    required init(name: String, weight: Int, color: String) {
        self.name = name
        self.weight = weight
        self.color = color
    }
}

extension Goat :FormModel {
    func form() -> Form {
        return Form(sections:[FormSection(rows:[
            TextEntryFormRow(name:"Name", tag: "name", value:name, validation: RequiredString("Name")),
            TextEntryFormRow(name:"Weight", tag: "weight", value:weight, textType: TextEntryType.Number, validation: MinimumNumber("Weight", 0)),
            TextEntryFormRow(name:"Color", tag: "color", value:color, validation: RequiredString("Color")),
            ])])
    }
    static func form() -> Form {
        return Form(sections:[FormSection(rows:[
            TextEntryFormRow(name:"Name", tag: "name", validation: RequiredString("Name")),
            TextEntryFormRow(name:"Weight", tag: "weight", textType: TextEntryType.Number, validation: MinimumNumber("Weight", 0)),
            TextEntryFormRow(name:"Color", tag: "color", validation: RequiredString("Color")),
            ])])
    }
    static func model(form :Form) -> Self? {
        let formValues = values(form)
        if let name = formValues["name"] as? String, let weight = formValues[""] as? Int, let color = formValues["color"] as? String {
            return self(name: name, weight: weight, color: color)
        }
        return nil
    }
}

