//
//  Const.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation
import Alamofire

//  API URLS
let DEV_MODE = false
let PUBLISH_MODE = false
let LIVE_PAYMENT = false
let DEV_SERVER = "http://192.168.109.72"
let PRODUCT_SERVER = PUBLISH_MODE ? "https://panel.blownup.co" : "http://dev-panel.blownup.co"
let BASE_SERVER = DEV_MODE ? DEV_SERVER : PRODUCT_SERVER

//  STRIPE PUBLISHABLE KEY
let STRIPE_PK_TEST = "pk_test_51IVQTuFmwQHroLNotyVUdfmRP83uYbtaecmidNUa1JdtnLUpySuEx5mzhF1E4fm46VG038uvsLBWBkaDYV72WZfV00vRbnMLv0"
let STRIPE_PK_LIVE = "pk_live_51IVQTuFmwQHroLNo5y9JhLuPnnbpMC2aG0PKGiNqAiuVjN5B4SCzURwetu4ZFNZzix6SV5XLTfp4O3THStK7OyGo002pHFXAxT"
let STRIPE_KEY = LIVE_PAYMENT ? STRIPE_PK_LIVE : STRIPE_PK_TEST

//  STORE KEYS
let API_TOKEN = "API_TOKEN"
let USER_PROFILE = "USER_PROFILE"
let REMEMBER_ME = "REMEMBER_ME"
let SUBSCRIPTION_UPCOMING_DATE = "SUBSCRIPTION_UPCOMING_DATE"
let IS_SUBSCRIPTION_ENDED = "IS_SUBSCRIPTION_ENDED"
let IS_SUBSCRIPTION_CANCELLED = "IS_SUBSCRIPTION_CANCELLED"
let APPLE_USER_ID = "APPLE_USER_ID"
let APPLE_USER_EMAIL = "APPLE_USER_EMAIL"

//  ViewControllers
let VC_LOGIN = "LoginVC"
let VC_SIGN_UP = "SignUpVC"
let VC_CARD_REGISTER = "CardRegisterVC"
let VC_SUCCESS = "SuccessVC"
let VC_RECENT_CALL = "RecentCallVC"
let VC_MAIN_TAB = "MainTabVC"
let VC_SCHEDULE_ADD = "ScheduleAddVC"
let VC_SCHEDULE_LIST = "ScheduleListVC"
let VC_CONTACT_ADD = "ContactAddVC"
let VC_CONTACT_LIST = "ContactListVC"
let VC_SETTING = "SettingVC"
let VC_HELP = "HelpVC"
let VC_ACCOUNT = "AccountVC"

//  API REQUEST HEADER
let HEADER = [ "Content-Type": "application/json"]
func BEARER_HEADER() -> HTTPHeaders {
    return [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(Store.instance.apiToken)"]
}

//  Sign In/Up
let URL_LOGIN = "\(BASE_SERVER)/api/login"
let URL_SIGN_UP = "\(BASE_SERVER)/api/signup"

//  Credit Card
let URL_CARD_GET = "\(BASE_SERVER)/api/card"
let URL_CARD_ADD = "\(BASE_SERVER)/api/card/add"

//  Subscription
let URL_SUBSCRIPTION_STATUS = "\(BASE_SERVER)/api/subscription/status"
let URL_BILLING_HISTORY = "\(BASE_SERVER)/api/invoice/all"
let URL_SUBSCRIPTION_CANCEL = "\(BASE_SERVER)/api/subscription/cancel"
let URL_SUBSCRIPTION_RESUME = "\(BASE_SERVER)/api/subscription/resume"

//  Recent Call
let URL_RECENT_CALL_GET = "\(BASE_SERVER)/api/recent_call"
let URL_RECENT_CALL_ADD = "\(BASE_SERVER)/api/recent_call/add"

//  Schedule
let URL_SCHEDULE_GET = "\(BASE_SERVER)/api/schedule"
let URL_SCHEDULE_ADD_GET = "\(BASE_SERVER)/api/schedule/add"
let URL_SCHEDULE_UPDATE_GET = "\(BASE_SERVER)/api/schedule/update"
let URL_SCHEDULE_DELETE_GET = "\(BASE_SERVER)/api/schedule/delete"
