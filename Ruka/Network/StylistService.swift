//
//  StylistService.swift
//  Ruka
//
//  Created by George on 2018/04/05.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON



protocol StylistProtocol {
     func getAllService( completion: @escaping ((StylistService.ServiceResult) -> Void) )
     func addService(name: String,price: String,address: String,latitude: Double,longitude: Double,phone: String,description: String, email: String,image_uri: String,available_time: String, completion: @escaping ((StylistService.addServiceResult) -> Void) )
     func upLoadImage(imageData: Data?,completion: @escaping ((StylistService.uploadResult) -> Void) )
}


class StylistService: StylistProtocol {

    
   
    var serviceList = [Service]()
    
    enum ServiceResult {
        case Success([Service])
        case Failure(String)
    }
    
    
    enum addServiceResult {
        case Success(String)
        case Failure(String)
    }
    
    enum uploadResult {
        case Success(String)
        case Failure(String)
    }

    
    func getAllService(completion: @escaping ((StylistService.ServiceResult) -> Void)) {
        Alamofire.request(ALL_SERVICE_URL, method: .get, parameters: nil
            ,encoding: URLEncoding.default, headers: HEADER).responseJSON { (response) in
                if response.result.error == nil {
                    self.serviceList.removeAll()
                    guard let data = response.data else {return}
                    let json = JSON(data: data).array
                    debugPrint(response.result)
                    for item in json! {
                        let _id = item["_id"].stringValue
                        let name = item["name"].stringValue
                        let price = item["price"].stringValue
                        let address = item["address"].stringValue
                        let latitude = item["latitude"].stringValue
                        let email_address = item["email_address"].stringValue
                        let phone = item["phone"].stringValue
                        let service_description = item["service_description"].stringValue
                        let image_uri = item["image_uri"].stringValue
                        let available_time = item["available_time"].stringValue
                        debugPrint(name)
                        let service = Service(_id: _id, name: name, price: price, address: address, latitude: latitude, email_address: email_address, phone: phone, service_description: service_description, image_uri: image_uri, available_time: available_time)
                        self.serviceList.append(service)
                    }
                    completion(ServiceResult.Success(self.serviceList.reversed()))
                }else{
                      debugPrint(response.result.error as Any)
                    completion(ServiceResult.Failure(DATA_ERROR))
                }
        }
        
    }
    
    
    func addService(name: String,price: String,address: String,latitude: Double,longitude: Double,phone: String,description: String, email: String,image_uri: String,available_time: String, completion: @escaping ((StylistService.addServiceResult) -> Void)) {
        let lowercasedemail = email.lowercased()
        let body  = [ "name": name,
                      "price": price,
                      "address": address,
                      "latitude": latitude,
                      "longitude": longitude,
                      "email_address": lowercasedemail,
                      "phone": phone,
                      "service_description": description,
                      "image_uri": image_uri,
                      "available_time": available_time,
            ] as [String : Any]
        let BEARER_HEADER = [
            "Authorization":"Bearer \(AuthenticationService.instance.auth_token)",
            "Content-Type": "application/json; charset=utf-8"
        ]
        Alamofire.request(ADD_SERVICE_URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers:  BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                debugPrint(response.result)
                if response.response?.statusCode == 200 {
                    completion(addServiceResult.Success("success"))
                }else{
                    completion(addServiceResult.Failure("failure"))
                }
            }else{
                debugPrint(response.result.error as Any)
                completion(addServiceResult.Failure("failure"))
            }
        }
    }
    
    
    func upLoadImage(imageData: Data?, completion: @escaping ((StylistService.uploadResult) -> Void)) {
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
                        completion(uploadResult.Failure(err.localizedDescription))
                        return
                    }
                    _ = json["message"].stringValue
                    _ = json["err_msg"].stringValue
                    let fileUrl = json["fileUrl"].stringValue
                    completion(uploadResult.Success(fileUrl.lowercased()))
                    
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completion(uploadResult.Failure(error.localizedDescription))
            }
        }
    }
    
}
