//
//  StudentLocation.swift
//  On The Map
//
//  Created by user on 10/02/2021.
//

import Foundation

class StudentInformationClient {
    
    enum EndPoints {
        
        static let studentLocationLink = "https://onthemap-api.udacity.com/v1/StudentLocation"
        
        case getStudentLocation
        case postStudentLocation
        case getPublicUser
        
        var stringValue: String {
            switch self {
            case .getStudentLocation: return EndPoints.studentLocationLink + "?order=-updatedAt"
            case .postStudentLocation: return EndPoints.studentLocationLink
            case .getPublicUser: return "https://onthemap-api.udacity.com/v1/users/\(Authentication.session!.account.key)"
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
                print(String(data: data, encoding: .utf8)!)
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
    
    func postStudentLocation(studentLocation: StudentLocation, completionHandler: @escaping (Error?) -> Void){
        let url = EndPoints.postStudentLocation.url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(studentLocation)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let _ = data else {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            // once the user location has been posted, I need to get the recent student location
            self.getAllStudentLocation { (data, error) in
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
        task.resume()
    }
    
    func getUserData(completionHandler: @escaping (User?, Error?) -> Void){
        
        let url = EndPoints.getPublicUser.url
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            do {
                let user = try decoder.decode(User.self, from: newData)
            
                DispatchQueue.main.async {
                    completionHandler(user, nil)
                }
                
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
        
        task.resume()
    }
}

