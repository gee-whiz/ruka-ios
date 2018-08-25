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
}


class StylistService: StylistProtocol {
   
    var serviceList = [Service]()
    enum ServiceResult {
        case Success([Service])
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
    
    
    
}
