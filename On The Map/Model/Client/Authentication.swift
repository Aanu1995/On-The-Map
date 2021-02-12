//
//  Authentication.swift
//  On The Map
//
//  Created by user on 09/02/2021.
//

import Foundation
import FBSDKLoginKit

struct Authentication {
    
    // MARK: Properties
    
    let loginManager = LoginManager()
    static var session: GETSession?
    
    
    enum EndPoints {
        
        static let sessionLink = "https://onthemap-api.udacity.com/v1/session"
        static let signUpLink = "https://auth.udacity.com/sign-up"
        
        case getSession
        case deleteSession
        case signUp
        
        var stringValue: String {
            switch self {
            case .getSession, .deleteSession : return EndPoints.sessionLink
            case .signUp: return EndPoints.signUpLink
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
    
    
    func login (username: String, password: String, completionHandler: @escaping (Any?, Error?)-> Void){
        var request = URLRequest(url: EndPoints.getSession.url)
        let body = PostSession(udacity: PostSession.Udacity(username: username, password: password))
        
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
            
            let decoder = JSONDecoder()
            
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            
            do {

                let result = try decoder.decode(GETSession.self, from: newData)
                Authentication.session = result
                
                DispatchQueue.main.async {
                    completionHandler(result, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OnTheMapError.self, from: newData)
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                }catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func deleteSession(completionHandler: @escaping (Error?) -> Void) {
        var request = URLRequest(url: EndPoints.deleteSession.url)
        
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
          guard let _ = data else {
              return completionHandler(error)
          }
            
            completionHandler(nil)
        }
        task.resume()
    }

    
    
    func facebookAuthentication(viewController: UIViewController, completionHandler: @escaping (Any?, Error?) -> Void){
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: viewController) { (result) in
            switch result {
            case .cancelled:
                completionHandler(nil, CustomError(title: "", description: "", code: 1))
            case .failed(let error):
                completionHandler(nil, error)
            case .success(granted: _, declined: _, token: _):
                getFaceBookData { (result, error) in
                    guard let result = result else {
                       return completionHandler(nil, error)
                    }
                    completionHandler(result, nil)
                }
            }
        }
    }
    
    func getFaceBookData(completionHandler: @escaping (Any?, Error?) -> Void){
        if let token = AccessToken.current, !token.isExpired {
             let accessToken = token.tokenString
            getParameter(token: accessToken) { (result, error) in
                guard let result = result else {
                    return completionHandler(nil, error)
                }
                return completionHandler(result, nil)
            }
        }
        completionHandler(nil, CustomError(title: "", description: "", code: 1))
    }
    
    func getParameter(token:String, completionHandler: @escaping (Any?, Error?) -> Void){
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        
        request.start { (connection, result, error) in
            
            guard let result = result else {
                return DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
            print(result)
            DispatchQueue.main.async {
               completionHandler(result, error)
            }
        }
    }
    
    
    func logout(completionHandler: @escaping (Error?) -> Void){
        if let _ = AccessToken.current {
            loginManager.logOut()
            return completionHandler(nil)
        }
        
        if let _ = Authentication.session {
            deleteSession { (error) in
                DispatchQueue.main.async {
                    if let error = error {
                      return completionHandler(error)
                    }
                    Authentication.session = nil
                    completionHandler(nil)
                }
            }
            return
        }
        completionHandler(nil)
    }
    
   
}

