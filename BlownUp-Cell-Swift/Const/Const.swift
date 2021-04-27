//
//  Const.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation

//  API URLS
let DEV_MODE = true
let DEV_SERVER = "http://192.168.109.72"
let PRODUCT_SERVER = "httpL//panel.blownup.co"
let BASE_SERVER = DEV_MODE ? DEV_SERVER : PRODUCT_SERVER

//  Sign In/Up
let URL_LOGIN = "\(BASE_SERVER)/api/login"

//  STORE KEYS
let API_TOKEN = "API_TOKEN"
let USER_PROFILE = "USER_PROFILE"

//  API REQUEST HEADER
let HEADER = [ "Content-Type": "application/json"]
let BEARER_HEADER = [
    "Content-Type": "application/json",
    "Authorization": "\(Store.instance.apiToken)"]
