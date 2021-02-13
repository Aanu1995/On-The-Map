//
//  StudentLocation.swift
//  On The Map
//
//  Created by user on 10/02/2021.
//

import Foundation

class InfoData {
    
    static let shared = InfoData()
    
    private init(){}
    
    var studentInfoList: [InformationModel] = []
    var session: GETSession?
}
