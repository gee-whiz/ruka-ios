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

//work
//let BASE_URL  = "http://192.168.3.80:3005/v1/"


//home
//let BASE_URL  = "http://192.168.0.103:3005/v1/"


let LOGIN_URL = "\(BASE_URL)account/login"
let REGISTER_URL = "\(BASE_URL)account/register"



let ALL_CATEGORIES_URL = "\(BASE_URL)service/category"
let ALL_PROMO_URL = "\(BASE_URL)promotions"
let ALL_SERVICE_URL = "\(BASE_URL)service/byCategoryId/"
let ADD_SERVICE_URL = "\(BASE_URL)service/add/"
let GET_REVIEWS_URL = "\(BASE_URL)service/reviews/"
let GET_PROFILE_URL = "\(BASE_URL)profile/byEmail/"

let ADD_PROFILE_URL = "\(BASE_URL)profile/add"

let UPDATE_PROFILE_URL = "\(BASE_URL)profile/"

let ADD_IMAGE_URL = "\(BASE_URL)server/upload"

let HAS_SEEN_ON_BOARD  = "HAS_SEEN_ON_BOARD"
let LOGGED_IN_KEY = "loggedin"
let USER_EMAIL  = "user_email"
let USER_NAME = "user_name"
let USER_TOKEN  = "auth_token"
let USER_ID  = "user_id"
let UPDATEPROFILE = "UPDATE_PROFILE"
let RELOAD  = "reload"
//Headers
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]


let AUTH_HEADER = [
    "Authorization":"Bearer \(AuthenticationService.instance.auth_token)",
    "Content-Type": "application/json; charset=utf-8"
]



//Error msg
let SERVICE_ERROR = "We're having trouble connecting to the service, please try again later."
let NETWORK_ERROR =  "No internet connection."
let DATA_ERROR  =  "We're having trouble processing  data, please try again."
let NETWORKNOTREACHABLE =  "networkNotRechable"
let NETWORKAVAILBLE = "networkAvailble"
