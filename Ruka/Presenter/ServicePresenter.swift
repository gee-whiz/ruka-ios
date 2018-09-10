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
    var category: Observable<[Category]>
    var promotion: Observable<[Promotion]>
    var review: Observable<[Review]>
    var addServiceMsg: Observable<String>
    var imageUrl: Observable<String>
    
    init() {
        
        self.errorMsg  = Observable("")
        self.imageUrl  = Observable("")
        self.addServiceMsg = Observable("")
        self.service  = Observable([])
        self.category  = Observable([])
        self.promotion  = Observable([])
        self.review  = Observable([])
        self.stylistService = StylistService()
        
        
    }
    
    func getAllService(categoryId: String) {
        self.stylistService.getAllService(categoryId: categoryId, completion: {(results) in
            switch (results) {
            case .Success(let result):
                self.service.value = result
                self.errorMsg.value  = ""
            case .Failure(let error):
                self.errorMsg.value  = error
            }
        })
    }
    
    func getAllCategories() {
        self.stylistService.getAllCategories(completion: {(results) in
            switch (results) {
            case .Success(let result):
                self.category.value = result
                self.errorMsg.value  = ""
            case .Failure(let error):
                self.errorMsg.value  = error
            }
        })
    }
    
    
    func getAllPromotions() {
        self.stylistService.getAllPromotions(completion: {(results) in
            switch (results) {
            case .Success(let result):
                self.promotion.value = result
                self.errorMsg.value  = ""
            case .Failure(let error):
                self.errorMsg.value  = error
            }
        })
    }
    
    func getReviews(serviceId: String) {
        self.stylistService.getReviews(serviceId: serviceId) { (results) in
            switch (results) {
            case .Success(let result):
                self.review.value = result
                self.errorMsg.value  = ""
            case .Failure(let error):
                self.errorMsg.value  = error
            }
        }

    }
    
    func addService(name: String,category: String,price: String,address: String,latitude: Double,longitude: Double,phone: String,description: String, email: String,image_uri: String,available_time: String){
        self.stylistService.addService(name: name,category: category, price: price, address: address, latitude: latitude, longitude: longitude, phone: phone, description: description, email: email, image_uri: image_uri, available_time: available_time) { (results) in
            switch (results) {
            case .Success( _):
                self.getAllService(categoryId: category)
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
