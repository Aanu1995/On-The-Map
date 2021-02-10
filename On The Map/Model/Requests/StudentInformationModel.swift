//
//  StudentLocationModel.swift
//  On The Map
//
//  Created by user on 10/02/2021.
//

import Foundation

struct StudentInformationModel: Codable {
    let results: [InformationModel]
}

struct InformationModel: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mediaURL: String
    let mapString: String
    let createdAt: String
    let updatedAt: String
    let uniqueKey: String
    let objectId: String
}

