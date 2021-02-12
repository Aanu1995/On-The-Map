//
//  Session.swift
//  On The Map
//
//  Created by user on 09/02/2021.
//

import Foundation

struct GETSession: Decodable {
    let account: Account
    let session: Session
    
    struct Account: Decodable {
        let key: String
    }
    
    struct Session: Decodable {
        let sessionId: String
        let expiration: String
        
        enum CodingKeys: String, CodingKey{
            case sessionId = "id"
            case expiration
        }
    }
    
}

struct PostSession: Encodable {
    let udacity: Udacity
    
    struct Udacity: Encodable {
        let username: String
        let password: String
    }
}

