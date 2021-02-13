//
//  Request.swift
//  On The Map
//
//  Created by user on 09/02/2021.
//

import Foundation


    
func taskForGetRequest (url:URL, completionHandler: @escaping (Data?, Error?) -> Void){
    
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(data, nil)
            }
        }
        task.resume()
    }
    
    
func taskForPostRequest<RequestType: Encodable>(url: URL, body: RequestType, completionHandler: @escaping (Data?, Error?)->Void){
        
        var request = URLRequest(url:url)
        
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                   completionHandler(nil, error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(data, nil)
            }
        }
        
        task.resume()
    }

