//
//  AutheticationPresenter.swift
//  Ruka
//
//  Created by George on 2018/03/14.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import Foundation




class AuthenticationPresenter {

    
    private var loginService: AuthenticationProtocol
    private var registerService :AuthenticationProtocol
    private var userService: UserProtocol
    
      var errorMsg: Observable<String>
      var auth_token: Observable<String>
       var registerMsg: Observable<String>
    
    
    init() {
        self.loginService = AuthenticationService()
        self.registerService = AuthenticationService()
        self.userService = UserService()
        self.errorMsg  = Observable("")
        self.auth_token  =  Observable("")
        self.registerMsg  = Observable("")
    }
    
    
    
    func loginWithEmail(email: String, password: String) {
        self.loginService.loginUser(email: email, password: password, completionHandler: {(results) in
            switch (results) {
            case .Success(let result):
                self.auth_token.value  = result
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: UPDATEPROFILE),object: nil)
                self.errorMsg.value  = ""
            case .Failure(let error):
                self.errorMsg.value  = error
            }
        })
        
    }
    
    
    func registerWithEmail(email: String, password: String) {
        self.loginService.registerUser(email: email, password: password, completionHandler: {(results) in
            switch (results) {
            case .Success(let result):
                if result == "success" {
                    self.loginWithEmail(email: email, password: password)
                }
                self.errorMsg.value  = ""
            case .Failure(let error):
                self.errorMsg.value  = error
            }
        })
        
    }
    
    func createUser(emai: String) {
        self.userService.createUser(email: emai, completion: {(results) in
            switch (results) {
            case .Success(let result):
                self.registerMsg.value  = result
                self.errorMsg.value  = ""
            case .Failure(let error):
                self.errorMsg.value  = error
            }
        })
    }
    
}
