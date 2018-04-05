//
//  AuthenticationService.swift
//  Ruka
//
//  Created by George on 2018/03/14.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


protocol AuthenticationProtocol {
    func loginUser(email: String, password: String,completionHandler: @escaping (AuthenticationService.LoginResult) -> Void)
    func registerUser(email: String, password: String,completionHandler: @escaping (AuthenticationService.LoginResult) -> Void)
}

class AuthenticationService: AuthenticationProtocol {
   

    
 
    enum LoginResult {
        case Success(String)
        case Failure(String)
    }
    
    
    static let  instance =  AuthenticationService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            return defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var auth_token: String {
        get {
            return defaults.value(forKey: USER_TOKEN) as? String ?? ""
        }
        
        set {
            return  defaults.set(newValue, forKey: USER_TOKEN)
        }
    }
    
    var user_id: String {
        get {
            return defaults.value(forKey: USER_ID) as? String ?? ""
        }
        
        set {
            return  defaults.set(newValue, forKey: USER_ID)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as? String ?? ""
        }
        
        set {
            return  defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    
    func loginUser(email: String, password: String, completionHandler: @escaping (AuthenticationService.LoginResult) -> Void) {
        let lowercasedemail = email.lowercased()
        let body  = [ "email": lowercasedemail,
                      "password": password
                    ]
        
        
        debugPrint(body)
        Alamofire.request(LOGIN_URL, method: .post, parameters: body, encoding: URLEncoding.queryString, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data: data)
                debugPrint(json)
                self.userEmail  = json["email"].stringValue
                self.auth_token  = json["token"].stringValue
                self.isLoggedIn  = true
                self.defaults.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:  LOGGED_IN_KEY),object: nil)
                completionHandler(LoginResult.Success(self.auth_token))
            }else{
                debugPrint(response.result.error as Any)
                completionHandler(LoginResult.Failure("failure"))
                
            }
        }
        
        
        
    }
    
    
    
    func registerUser(email: String, password: String, completionHandler: @escaping (AuthenticationService.LoginResult) -> Void) {
        let lowercasedemail = email.lowercased()
        let body  = [ "email": lowercasedemail,
                      "password": password
        ]
      
        
        debugPrint(body)
        Alamofire.request(REGISTER_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data: data)
                debugPrint(response.result)
                let name = json["name"].stringValue
                let msg  = json["message"].stringValue
                
                if name == "UserExistsError" {
                  completionHandler(LoginResult.Failure(msg))
                }else{
                    completionHandler(LoginResult.Success("success"))
                }
             
            }else{
                debugPrint(response.result.error as Any)
                completionHandler(LoginResult.Failure("failure"))
                
            }
            
            
        }
        
    }
    
    
    
}

struct ParameterQueryEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = parameters?
            .map { "\($0)=\($1)" }
            .joined(separator: "&")
            .data(using: .utf8)
        return request
    }
}
