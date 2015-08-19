//
//  Model.swift
//  Formulary
//
//  Created by Fabian Canas on 8/12/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

public protocol FormModel :class {
    /// Returns a Form structured according to the receiving FormModel, populated with the Model instance's values
    func form() -> Form
    /// Returns a Form structured according to Model with empty values
    static func form() -> Form
    /// Given a Form, attempts to return a Model populated with the Form's fields' values
    static func model(form: Form) -> Self?
    /// A single string summarizing the model
    var summary :String { get }
}
