//
//  Validation.swift
//  On The Map
//
//  Created by user on 04/02/2021.
//

import Foundation

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

func isValidURL(_ url: String) -> Bool {
    let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
    return predicate.evaluate(with: url)
}
