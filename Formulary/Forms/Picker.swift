//
//  Picker.swift
//  Formulary
//
//  Created by Fabian Canas on 12/31/15.
//  Copyright © 2015 Fabian Canas. All rights reserved.
//


//MARK: Form Row

/**
* PickerFormRow is a type of FormRow that allows for picking one item from an 
* arbitrary list of items via a UIPicker control
*
* To use a picker form row, it is only necessary to create one, add it to a
* FormSection, and add that FormSection to a Form.
*
* - seealso: `FormRow`
*/
public class PickerFormRow : FormRow, FormularyComponent {
    
    private static var registrationToken :Int = 0
    private static let CellIdentifier = "Formulary.Picker"
    
    /**
     * A cell reuse identifier used by Formulary to create table view cells that
     * correspond to the picker form row.
     */
    override public var cellIdentifier :String {
        get {
            return PickerFormRow.CellIdentifier
        }
    }
    
    /**
     * Associate a reuse identifier with a UITableViewCell class
     *
     * This method is used to register a picker as a Formulary component. This 
     * is done automatically once the first time a Picker cell is
     * created. There is no need to use this function.
     */
    public static func cellRegistration() -> [String : AnyClass] {
        return [PickerFormRow.CellIdentifier : PickerCell.self]
    }
    
    private let options: [String]
    
    /**
     * Initialized a Picker Form Row with the provided options.
     *
     * The value property of the FormRow will contain the String value 
     * corresponding to the currently selected picker item.
     */
    public init(name: String, tag: String? = nil, options: [String], action :Action? = nil) {
        
        dispatch_once(&PickerFormRow.registrationToken, { () -> Void in
            registerFormularyComponent(PickerFormRow.self)
        })
        
        self.options = options
        super.init(name: name, tag: tag, type: .Specialized, value: nil)
    }

}

class PickerCell: UITableViewCell, FormTableViewCell {
    let pickerControl :UIPickerView = UIPickerView()
    
    /// Indicates whether the cell has been configured
    var configured: Bool = false
    
    private var pickerAdapter :PickerAdapter?
    
    /// The FormRow model object the cell represents, if any
    var formRow: FormRow? {
        didSet {
            guard let formRow = formRow as? PickerFormRow else {
                self.formRow = nil
                return
            }
            pickerAdapter = PickerAdapter(options: formRow.options) { (value) -> Void in
                formRow.value = value
            }
            pickerControl.delegate = pickerAdapter
            pickerControl.dataSource = pickerAdapter
            if !configured {
                pickerControl.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(pickerControl)
                contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[pickerControl]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["pickerControl":pickerControl]))
                contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[pickerControl]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["pickerControl":pickerControl]))
                configured = true
            }
        }
    }
    
    /// An optional Action associated with the cell. Typically gets executed when the cell is tapped.
    var action :Action?
}

private class PickerAdapter : NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let options :[String]

    private let changeAction :((String)->Void)
    
    init(options: [String], changeAction: (String) -> Void) {
        self.options = options
        self.changeAction = changeAction
        super.init()
    }
    
    @objc func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    @objc func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    @objc func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    @objc func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        changeAction(options[row])
    }
}
