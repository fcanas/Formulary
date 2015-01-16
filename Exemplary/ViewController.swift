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
        self.form = Form(sections: [FormSection(name:"Letters", rows: [FormRow(name:"A"), FormRow(name:"B"), FormRow(name:"C")]),
                                    FormSection(name:"Vówels", rows: [FormRow(name:"á"), FormRow(name:"é"), FormRow(name:"í")])])
    }
    
}

