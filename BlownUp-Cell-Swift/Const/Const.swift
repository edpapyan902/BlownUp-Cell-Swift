//
//  Const.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation

//  API URLS
let DEV_MODE = true
let PUBLISH_MODE = false
let DEV_SERVER = "http://192.168.109.72"
let PRODUCT_SERVER = PUBLISH_MODE ? "https://panel.blownup.co" : "http://dev-panel.blownup.co"
let BASE_SERVER = DEV_MODE ? DEV_SERVER : PRODUCT_SERVER

//  Sign In/Up
let URL_LOGIN = "\(BASE_SERVER)/api/login"
let URL_SIGN_UP = "\(BASE_SERVER)/api/signup"

//  STORE KEYS
let API_TOKEN = "API_TOKEN"
let USER_PROFILE = "USER_PROFILE"
let REMEMBER_ME = "REMEMBER_ME"
let SUBSCRIPTION_UPCOMING_DATE = "SUBSCRIPTION_UPCOMING_DATE"
let IS_SUBSCRIPTION_ENDED = "IS_SUBSCRIPTION_ENDED"
let IS_SUBSCRIPTION_CANCELLED = "IS_SUBSCRIPTION_CANCELLED"

//  API REQUEST HEADER
let HEADER = [ "Content-Type": "application/json"]
let BEARER_HEADER = [
    "Content-Type": "application/json",
    "Authorization": "\(Store.instance.apiToken)"]
