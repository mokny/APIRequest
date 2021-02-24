//
//  APIRequest.swift
//
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
    
    private var APIUrl = ""
    private var UserAgent = "APIRequest"
    private var APIKey = ""
    
    init(apiurl: String, apikey: String) {
        self.APIUrl = apiurl
        self.APIKey = apikey
    }
    
    struct ResponseStruct {
        var Result = ""
        var Timestamp = 0
        var Data = [String: Any]()
        var ServerData = ""
        var Raw = ""
    }
    
    public var Response = ResponseStruct()
    private var IsBusy = false
    public var BlockWhenBusy = false
    
    //Public function to make the call
    public func call(method: String,parameters: Dictionary<String, Any>, ResponseHandler: @escaping (Bool) -> Any) -> Bool {
        if (BlockWhenBusy && IsBusy) {
            print("API: Request cancelled - Busy.")
            ResponseHandler(false)
            return false
        }
        self.IsBusy = true
        do {
            try self.makerequest(method: method, parameters: parameters, ResponseHandler: ResponseHandler)

        } catch {
            print("API: Unexpected error")
            return false
        }
        return true
    }
    
    //Internal function that makes the API Request
    private func makerequest(method: String, parameters: Dictionary<String, Any>, ResponseHandler: @escaping (Bool) -> Any) {
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["User-Agent": self.UserAgent]
        
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
        postparams["APIKEY"] = self.APIKey
        
        //Encode POST Parameters
        request.httpBody = postparams.percentEncoded()

        //Start URLSession
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { (data, response, error) in

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    DispatchQueue.main.async {
                        //Set Response variables
                        if let dictionary = json as? [String: Any] {
                            self.Response.Result = dictionary["RESULT"] as! String
                            self.Response.Timestamp = dictionary["TIMESTAMP"] as! Int
                            self.Response.Data = dictionary["DATA"] as! Dictionary
                            self.Response.Raw = String(data: data, encoding: .utf8)!
                        }
                        //Call ResponseHandler
                        ResponseHandler(true)
                        self.IsBusy = false
                    }

                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    public func SetUserAgent(agent: String) {
        self.UserAgent = agent
    }
}
