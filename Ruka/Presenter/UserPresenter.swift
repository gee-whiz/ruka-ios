//
//  UserPresenter.swift
//  Ruka
//
//  Created by George on 2018/04/07.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import Foundation


class UserPresenter {
    
    
    
    private var userService: UserProtocol
    
    var errorMsg: Observable<String>
    var profilePicUrl: Observable<String>
    var user: Observable<[User]>
    var updateMsg: Observable<String>
    
    
    init() {
        
        self.errorMsg  = Observable("")
        self.updateMsg  = Observable("")
        self.user  = Observable([])
        self.userService = UserService()
        self.profilePicUrl = Observable("")
        
    }
    
    func getProfile() {
        self.userService.getProfile(completion: {(results) in
            switch (results) {
            case .Success(let result):
                self.user.value = result
                self.errorMsg.value  = ""
            case .Failure(let error):
                self.errorMsg.value  = error
            }
        })
    }
    
    
    func updateUser(email: String,first_name: String,last_name: String,about: String,phone: String, profile_image_uri: String){
        self.userService.updateUser(email: email, first_name: first_name, last_name: last_name, about: about, phone: phone, profile_image_uri: profile_image_uri, completion: {(results) in
            switch (results) {
            case .Success( _):
                self.getProfile()
                self.updateMsg.value =  "Profile successfully updated"
                self.errorMsg.value  = ""
            case .Failure(let error):
                self.errorMsg.value  = error
            }
        })
    }
    
    func updateProfilePic(imageData: Data) {
        self.userService.updateProfilePic(imageData: imageData) { (results) in
            switch (results) {
            case .Success(let result):
                self.profilePicUrl.value  = result
                self.errorMsg.value  = ""
            case .Failure(let error):
                self.errorMsg.value  = error
            }
        }
    }
    
}
