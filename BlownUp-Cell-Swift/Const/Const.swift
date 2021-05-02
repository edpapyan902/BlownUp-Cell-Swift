//
//  Const.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation

//  API URLS
let DEV_MODE = false
let PUBLISH_MODE = false
let DEV_SERVER = "http://192.168.109.72"
let PRODUCT_SERVER = PUBLISH_MODE ? "https://panel.blownup.co" : "http://dev-panel.blownup.co"
let BASE_SERVER = DEV_MODE ? DEV_SERVER : PRODUCT_SERVER

//  STRIPE PUBLISHABLE KEY
let STRIPE_PK_TEST = "pk_test_51IVQTuFmwQHroLNotyVUdfmRP83uYbtaecmidNUa1JdtnLUpySuEx5mzhF1E4fm46VG038uvsLBWBkaDYV72WZfV00vRbnMLv0"
let STRIPE_PK_LIVE = "pk_live_51IVQTuFmwQHroLNo5y9JhLuPnnbpMC2aG0PKGiNqAiuVjN5B4SCzURwetu4ZFNZzix6SV5XLTfp4O3THStK7OyGo002pHFXAxT"
let STRIPE_KEY = PUBLISH_MODE ? STRIPE_PK_LIVE : STRIPE_PK_TEST

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
    "Authorization": "Bearer \(Store.instance.apiToken)"]

//  Sign In/Up
let URL_LOGIN = "\(BASE_SERVER)/api/login"
let URL_SIGN_UP = "\(BASE_SERVER)/api/signup"
let URL_SUBSCRIPTION_STATUS = "\(BASE_SERVER)/api/subscription/status"

//  Credit Card
let URL_CARD_GET = "\(BASE_SERVER)/api/card"
let URL_CARD_ADD = "\(BASE_SERVER)/api/card/add"
