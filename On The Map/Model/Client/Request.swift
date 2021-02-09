//
//  Request.swift
//  On The Map
//
//  Created by user on 09/02/2021.
//

import Foundation

class ServerRequest {
    
    class func taskForGetRequest<ResponseType: Decodable> (url:URL, responseType: ResponseType.Type, completionHandler: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask{
    
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let  token = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(token, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
    
    
    class func taskForPostRequest<ResponseType: Decodable, RequestType: Encodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completionHandler: @escaping (ResponseType?, Error?)->Void){
        
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
            
            let decoder = JSONDecoder()
            
            do{
                let jsonObject = try decoder.decode(ResponseType.self, from: data)
                
                DispatchQueue.main.async {
                    completionHandler(jsonObject, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
        }
        
        task.resume()
    }
}
