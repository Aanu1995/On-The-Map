//
//  StudentLocation.swift
//  On The Map
//
//  Created by user on 10/02/2021.
//

import Foundation

class StudentInformation {
    
    static let shared = StudentInformation()
    
    private init(){}
    
    var studentInfoList: [InformationModel] = []
    
}
