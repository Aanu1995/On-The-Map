//
//  User.swift
//  On The Map
//
//  Created by user on 12/02/2021.
//

import Foundation

struct User: Decodable {
    let firstName: String
    let lastName: String
    let uniqueKey: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case uniqueKey = "key"
    }
}
