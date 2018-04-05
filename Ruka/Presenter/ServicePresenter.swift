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
    
    
    
    init() {
        
        self.errorMsg  = Observable("")
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

}
