# Formulary

Formulary is a new library for creating dynamic, declarative, table view forms for iOS.

Formulary is in early stages of design and development, so if you jump in now, you can have a big impact on the library's design, power, and utility.

                   
Formulary is inspired by XLForm, written in Swift, and designed for simplicity and development speed.

Other cool features:

* "Floating Labels" for form fields.
* Composable validation functions

```swift
self.form = Form(sections: [
    FormSection(rows: [
        TextEntryFormRow(name:"Name", tag: "name", validation: RequiredString("Name")),
        TextEntryFormRow(name: "Email", tag: "email", textType: TextEntryType.Email),
        TextEntryFormRow(name:"Age", tag: "age", textType: TextEntryType.Number, validation: MinimumNumber("Age", 13))],
        name:"Profile"),
    FormSection(rows: [
        TextEntryFormRow(name:"Favorite Number", tag: "favoriteNumber", value: nil, textType: .Decimal, validation: MinimumNumber("Your favorite number", 47) && MaximumNumber("Your favorite number", 47)),
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
```

<img src="https://raw.github.com/fcanas/Formulary/master/Screenshots/animated-capture.gif" alt="Screen-Capture of Example Form" width="396" />
<!--![](/Screenshots/animated-capture.gif)-->


## Author

Fabian Canas ([@fcanas](http://twitter.com/fcanas))

## License

Formulary is available under the MIT license.
