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
        self.form = ConcreteForm(sections: [ConcreteFormSection(rows: [ConcreteFormRow(name:"A", tag: "a"),
                                                                       ConcreteFormRow(name:"B", tag: "b"),
                                                                       ConcreteFormRow(name:"C", tag: "c")],
                                                name:"Letters"),
                                            ConcreteFormSection(rows: [ConcreteFormRow(name:"á", tag: "á"),
                                                                       ConcreteFormRow(name:"é", tag: "é", value: false, type: .Switch),
                                                                       ConcreteFormRow(name:"í", tag: "í", value: true, type: .Switch)],
                                                name:"Vówels",
                                                footerName: "Fín")])
    }
    
}

