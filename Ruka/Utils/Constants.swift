//
//  Constants.swift
//  Ruka
//
//  Created by George on 2018/03/14.
//  Copyright © 2018 george kapoya. All rights reserved.
//

import Foundation



let BASE_URL  = "http://46.101.89.206/api/v1/"


//localhost
//let BASE_URL  = "http://127.0.0.1:3005/v1/"

let LOGIN_URL = "\(BASE_URL)account/login"
let REGISTER_URL = "\(BASE_URL)account/register"

let ALL_SERVICE_URL = "\(BASE_URL)service"

let HAS_SEEN_ON_BOARD  = "HAS_SEEN_ON_BOARD"
let LOGGED_IN_KEY = "loggedin"
let USER_EMAIL  = "user_email"
let USER_NAME = "user_name"
let USER_TOKEN  = "auth_token"
let USER_ID  = "user_id"

//Headers
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]



//Error msg
let SERVICE_ERROR = "We're having trouble connecting to the service, please try again later."
let NETWORK_ERROR =  "No internet connection."
let DATA_ERROR  =  "We're having trouble processing  data, please try again."

