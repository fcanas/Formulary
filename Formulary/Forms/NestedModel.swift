//
//  NestedModel.swift
//  Formulary
//
//  Created by Fabian Canas on 8/12/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

let NestedFormRowReuseIdentifier = "Formulary.NestedModel"

public class NestedFormRow: FormRow, FormularyComponent {
    public var formModel :FormModel? {
        get {
            return nil
        }
    }
    
    var form :Form
    
    public var summary :String?
    
    override var value :AnyObject? {
        get {
            return values(form)
        }
        set {
            
        }
    }
    
    override public var cellIdentifier :String {
        get { return NestedFormRowReuseIdentifier }
    }
    
    public init(name: String, tag: String, nestedModel: FormModel) {
        form = nestedModel.form()
        super.init(name: name, tag: tag, type: .Specialized, value: nil)
    }
    
    public init(name: String, tag: String, nestedModelType: FormModel.Type) {
        form = nestedModelType.form()
        super.init(name: name, tag: tag, type: .Specialized, value: nil)
    }
    
    public static func cellRegistration() -> [String : AnyClass] {
        return [NestedFormRowReuseIdentifier : NestedFormCell.self]
    }
}

class NestedFormCell :UITableViewCell, FormTableViewCell, ControllerSpringingCell {
    var configured :Bool = false
    var nestedViewController :(() -> UIViewController)?
    var formRow :FormRow? {
        didSet {
            if var formRow = formRow as? NestedFormRow {
                textLabel?.text = formRow.summary
                nestedViewController = {
                    let vc = FormViewController(form: formRow.form)
                    vc.navigationItem.rightBarButtonItem = vc.editButtonItem()
                    vc.editingEnabled = true
                    return vc
                }
                configured = true
            } else {
                textLabel?.text = nil
                configured = false
                nestedViewController = nil
            }
        }
    }
    var action :Action?
}
