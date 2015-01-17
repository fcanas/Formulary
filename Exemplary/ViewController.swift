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
        self.form = Form(sections: [FormSection(rows: [FormRow(name:"A", tag: "a"),
                                                       FormRow(name:"B", tag: "b"),
                                                       FormRow(name:"C", tag: "c")],
                                                name:"Letters"),
                                    FormSection(rows: [FormRow(name:"á", tag: "á"),
                                                       FormRow(name:"é", tag: "é", value: false, type: .Switch),
                                                       FormRow(name:"í", tag: "í", value: true, type: .Switch)],
                                                name:"Vówels",
                                                footerName: "Fín")])
    }
    
}

