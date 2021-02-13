//
//  StudentLocation.swift
//  On The Map
//
//  Created by user on 10/02/2021.
//

import Foundation

class StudentInformationClient {
    
    enum EndPoints {
        
        
        
        case getStudentLocation
        case postStudentLocation
        case getPublicUser
        
        var stringValue: String {
            let baseUrl = Constants.UdacityApi.BaseUrl
            let userBaseUrl = Constants.UdacityApi.UserBaseUrl
            
            switch self {
            case .getStudentLocation: return baseUrl + "?order=-updatedAt&limit=100"
            case .postStudentLocation: return baseUrl
            case .getPublicUser: return userBaseUrl + Authentication.session!.account.key
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
    }
    
    func  getAllStudentLocation(completionHandler: @escaping ([InformationModel], Error?) -> Void){
        let url = EndPoints.getStudentLocation.url
        
        ServerRequest.taskForGetRequest(url: url) { (data, error) in
            guard let data = data else {
                return completionHandler(StudentInformation.shared.studentInfoList, error)
            }
            
            let decoder = JSONDecoder()
            
            do {
                let studentsInfo = try decoder.decode(StudentInformationModel.self, from: data)
                // setting error to nil
                StudentInformation.shared.studentInfoList = studentsInfo.results
                completionHandler(StudentInformation.shared.studentInfoList, nil)
                // required to update the Map and Tabbed View
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notification.FetchNotifierIdentifier), object: nil)
                
            } catch {
                completionHandler(StudentInformation.shared.studentInfoList, error)
            }
        }
    }
    
    func postStudentLocation(studentLocation: StudentLocation, completionHandler: @escaping (Error?) -> Void){
        let url = EndPoints.postStudentLocation.url
        
        ServerRequest.taskForPostRequest(url: url, body: studentLocation) { (data, error) in
            guard let _ = data else {
                return completionHandler(error)
            }
            
            // once the user location has been posted, I need to get the recent student location
            self.getAllStudentLocation { (data, error) in
               completionHandler(nil)
            }
        }
        
    }
    
    func getUserData(completionHandler: @escaping (User?, Error?) -> Void){
        
        // if session is nil, then facebook is used to login in
        guard let _ = Authentication.session else {
            let user = User(firstName: "Johnny", lastName: "Snow", uniqueKey: "")
            return completionHandler(user, nil)
        }
        
        let url = EndPoints.getPublicUser.url
        
        ServerRequest.taskForGetRequest(url: url) { (data, error) in
            guard let data = data else {
                return  completionHandler(nil, error)
            }
            
            let decoder = JSONDecoder()
            
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            do {
                let user = try decoder.decode(User.self, from: newData)
                completionHandler(user, nil)
                
            } catch {
                completionHandler(nil, error)
            }
        }
       
    }
}

