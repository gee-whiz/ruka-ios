//
//  ServicePresenter.swift
//  Ruka
//
//  Created by George on 2018/04/05.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import Foundation


class ServicePresenter {
    
    
    
    private var stylistService: StylistProtocol

    var errorMsg: Observable<String>
    var service: Observable<[Service]>
    var addServiceMsg: Observable<String>
    var imageUrl: Observable<String>
    
    init() {
        
        self.errorMsg  = Observable("")
        self.imageUrl  = Observable("")
        self.addServiceMsg = Observable("")
        self.service  = Observable([])
        self.stylistService = StylistService()
        
        
    }
    
    func getAllService() {
        self.stylistService.getAllService(completion: {(results) in
            switch (results) {
            case .Success(let result):
                self.service.value = result
                self.errorMsg.value  = ""
            case .Failure(let error):
                self.errorMsg.value  = error
            }
        })
    }
    
    func addService(name: String,price: String,address: String,latitude: Double,longitude: Double,phone: String,description: String, email: String,image_uri: String,available_time: String){
        self.stylistService.addService(name: name, price: price, address: address, latitude: latitude, longitude: longitude, phone: phone, description: description, email: email, image_uri: image_uri, available_time: available_time) { (results) in
            switch (results) {
            case .Success( _):
                self.getAllService()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RELOAD),object: nil)
                self.addServiceMsg.value =  "Your Listing has been successfully added"
                self.errorMsg.value  = ""
            case .Failure(let error):
                self.errorMsg.value  = error
            }
        }
        
    }
    

    func uploadImage(imageData: Data) {
        self.stylistService.upLoadImage(imageData: imageData) { (results) in
            switch (results) {
            case .Success(let result):
                self.imageUrl.value  = result
                self.errorMsg.value  = ""
            case .Failure(let error):
                self.errorMsg.value  = error
            }
        }
    }

}
