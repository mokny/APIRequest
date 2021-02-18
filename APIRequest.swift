//
//  APIRequest.swift
//  MOKTEST
//
//  Created by Till Vennefrohne on 18.02.21.
//

import Foundation

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

class APIRequest  {
    
    var APIUrl = "http://example.com/json.php"
     
    struct ResponseStruct {
        var Result = ""
        var Timestamp = 0
        var Data = [String: String]()
        var ServerData = ""
    }
    
    var Response = ResponseStruct()
    
    
    static let sharedAPIRequest = APIRequest()
    
    //Public function to make the call
    public func call(method: String,parameters: Dictionary<String, Any>, ResponseHandler: @escaping (Any) -> Any) {
        self.makerequest(method: method, parameters: parameters, ResponseHandler: ResponseHandler)
    }
    
    //Internal function that makes the API Request
    private func makerequest(method: String, parameters: Dictionary<String, Any>, ResponseHandler: @escaping (Any) -> Any) {
        
        let url = URL(string: APIUrl)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        var postparams: [String: Any] = [:]
        
        //Add Parameters to POST Array
        for (param, content) in parameters {
            postparams[param] = content
        }
        
        postparams["METHOD"] = method //Make sure METHOD will not be overwritten
        
        //Encode POST Parameters
        request.httpBody = postparams.percentEncoded()

        //Start URLSession
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in

            if let data = data {
                do {
                    print(String(data: data, encoding: .utf8)!)
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    DispatchQueue.main.async {
                        //Set Response variables
                        if let dictionary = json as? [String: Any] {
                            self.Response.Result = dictionary["RESULT"] as! String
                            self.Response.Timestamp = dictionary["TIMESTAMP"] as! Int
                            self.Response.Data = dictionary["DATA"] as! Dictionary
                        }
                        
                        //Call ResponseHandler
                        ResponseHandler(json)
                    }

                    
                } catch {
                    print(error)
                }
            }
        }.resume()
 
        
    }
    

    
}
