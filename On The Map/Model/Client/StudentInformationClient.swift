//
//  StudentLocation.swift
//  On The Map
//
//  Created by user on 10/02/2021.
//

import Foundation

class StudentLocationClient {
    
    enum EndPoints {
        
        static let studentLocationLink = "https://onthemap-api.udacity.com/v1/StudentLocation"
        
        case getStudentLocation
        
        var stringValue: String {
            switch self {
            case .getStudentLocation: return EndPoints.studentLocationLink
             
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
    }
    
    func  getAllStudentLocation(completionHandler: @escaping ([InformationModel], Error?) -> Void){
        
        let url = EndPoints.getStudentLocation.url
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(StudentInformation.studentLocationList, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let studentsInfo = try decoder.decode(StudentInformationModel.self, from: data)
                // setting error to nil
                StudentInformation.studentLocationList = studentsInfo.results
                DispatchQueue.main.async {
                    completionHandler(StudentInformation.studentLocationList, nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.fetchNotifierIdentifier), object: nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completionHandler(StudentInformation.studentLocationList, error)
                }
            }
        }
        
        task.resume()
    }
    
}

