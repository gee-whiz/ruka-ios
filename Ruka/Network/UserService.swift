//
//  UserService.swift
//  Ruka
//
//  Created by George on 2018/04/07.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON



protocol UserProtocol {
    
    func getProfile( completion: @escaping ((UserService.UserResult) -> Void) )
    func updateUser(email: String,first_name: String,last_name: String,about: String,phone: String, profile_image_uri: String, completion: @escaping ((UserService.createResult) -> Void) )
    func createUser(email: String, completion: @escaping ((UserService.createResult) -> Void) )
    func updateProfilePic(imageData: Data?,completion: @escaping ((UserService.createResult) -> Void) )
    
}




class UserService: UserProtocol {
  
   let defaults = UserDefaults.standard
    var userList = [User]()
    enum UserResult {
        case Success([User])
        case Failure(String)
    }

    enum createResult {
        case Success(String)
        case Failure(String)
    }
    
    var user_id: String {
        get {
            return defaults.value(forKey: USER_ID) as? String ?? ""
        }
        
        set {
            return  defaults.set(newValue, forKey: USER_ID)
        }
    }
    
    func getProfile(completion: @escaping ((UserService.UserResult) -> Void)) {
        let BEARER_HEADER = [
            "Authorization":"Bearer \(AuthenticationService.instance.auth_token)",
            "Content-Type": "application/json; charset=utf-8"
        ]
        let url = "\(GET_PROFILE_URL)\(AuthenticationService.instance.userEmail)"
        Alamofire.request(url, method: .get, parameters: nil
            ,encoding: URLEncoding.default, headers:  BEARER_HEADER).responseJSON { (response) in
                if response.result.error == nil {
                    self.userList.removeAll()
                    guard let data = response.data else {return}
                    let json = JSON(data: data)
                    debugPrint(response.result)
                    let first_name = json["first_name"].stringValue
                    let last_name = json["last_name"].stringValue
                    let _id = json["_id"].stringValue
                    let email_address = json["email"].stringValue
                    let phone = json["phone"].stringValue
                    let about = json["about"].stringValue
                    let verified = json["verified"].boolValue
                    let profile_image_uri = json["profile_image_uri"].stringValue
                    self.user_id = _id
                    let user = User(_id: _id, email: email_address, first_name: first_name, last_name: last_name, about: about, phone: phone, verified: verified, profile_image_uri: profile_image_uri)
                    self.userList.append(user)
                    completion(UserResult.Success(self.userList))
                }else{
                    debugPrint(response.result.error as Any)
                    completion(UserResult.Failure(DATA_ERROR))
                }
        }
    }
    
    
    func updateUser(email: String, first_name: String, last_name: String, about: String, phone: String, profile_image_uri: String, completion: @escaping ((UserService.createResult) -> Void)) {
        let lowercasedemail = email.lowercased()
        let body  = [ "email": lowercasedemail,
                      "first_name": first_name,
                      "last_name": last_name,
                      "about": about,
                      "phone": phone,
                      "verified": 0,
                      "profile_image_uri": profile_image_uri
            ] as [String : Any]
        let BEARER_HEADER = [
            "Authorization":"Bearer \(AuthenticationService.instance.auth_token)",
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        let url = "\(UPDATE_PROFILE_URL)\(self.user_id)"
           debugPrint(url)
        Alamofire.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers:  BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                debugPrint(response.result)
                if response.response?.statusCode == 200 {
                    guard let data = response.data else {return}
                    let json = JSON(data: data)
                    let message = json["message"].stringValue
                    completion(createResult.Success(message))
                }else{
                    completion(createResult.Failure("failure"))
                }
            }else{
                debugPrint(response.result.error as Any)
                completion(createResult.Failure("failure"))
            }
        }
        
    }
    
    
    func createUser(email: String, completion: @escaping ((UserService.createResult) -> Void)) {
        let lowercasedemail = email.lowercased()
        let body  = [ "email": lowercasedemail,
                      "first_name": "",
                      "last_name": "",
                      "about": "",
                      "phone": "",
                      "verified": 0,
                      "profile_image_uri": ""
            ] as [String : Any]
        let BEARER_HEADER = [
            "Authorization":"Bearer \(AuthenticationService.instance.auth_token)",
            "Content-Type": "application/json; charset=utf-8"
        ]
        Alamofire.request(ADD_PROFILE_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers:  BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                 debugPrint(response.result)
                if response.response?.statusCode == 200 {
                     completion(createResult.Success("success"))
                }else{
                    completion(createResult.Failure("failure"))
                }
            }else{
                debugPrint(response.result.error as Any)
                completion(createResult.Failure("failure"))
            }
        }
    
    }
    
    func updateProfilePic(imageData: Data?, completion: @escaping ((UserService.createResult) -> Void)) {
        Alamofire.upload(multipartFormData: { (multipartFormData) in

            if let data = imageData{
                multipartFormData.append(data, withName: "file", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: ADD_IMAGE_URL, method: .post, headers: AUTH_HEADER) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    guard let data = response.data else {return}
                    
                    let json = JSON(data: data)
                    debugPrint(json)
                    print("Succesfully uploaded ", response)
                    if let err = response.error{
                        completion(createResult.Failure(err.localizedDescription))
                        return
                    }
                    _ = json["message"].stringValue
                    _ = json["err_msg"].stringValue
                    let fileUrl = json["fileUrl"].stringValue
                    completion(createResult.Success(fileUrl.lowercased()))
                    
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completion(createResult.Failure(error.localizedDescription))
            }
        }
    }
    
    

}
