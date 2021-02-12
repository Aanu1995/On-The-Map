//
//  StudentLocationModel.swift
//  On The Map
//
//  Created by user on 10/02/2021.
//

import Foundation

struct StudentInformationModel: Decodable {
    let results: [InformationModel]
}

struct InformationModel: Decodable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mediaURL: String
    var url: URL {
        return URL(string: self.mediaURL.replacingOccurrences(of: " ", with: "%20"))!
    }
    let mapString: String
    let createdAt: String
    let updatedAt: String
    let uniqueKey: String
    let objectId: String
}

struct StudentLocation: Encodable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mediaURL: String
    let mapString: String
    let uniqueKey: String
}

