//
//  API.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 27/04/2021.
//

import Foundation
import Alamofire
import AlamofireMapper

class API {
    
    static let instance = API()
    
    func login(params: [String: Any], completion: @escaping ( _ response: DataResponse<LoginRes>) -> Void) -> Void {
        Alamofire.request(URL_LOGIN, method: .post, parameters: params, encoding: JSONEncoding.default, headers: BEARER_HEADER()).responseObject { (response: DataResponse<LoginRes>) in
            completion(response)
        }
    }
    
    func signUp(params: [String: Any], completion: @escaping ( _ response: DataResponse<SignUpRes>) -> Void) -> Void {
        Alamofire.request(URL_SIGN_UP, method: .post, parameters: params, encoding: JSONEncoding.default, headers: BEARER_HEADER()).responseObject { (response: DataResponse<SignUpRes>) in
            completion(response)
        }
    }
    
    func getSubscriptionStatus(completion: @escaping ( _ response: DataResponse<SubscriptionRes>) -> Void) -> Void {
        Alamofire.request(URL_SUBSCRIPTION_STATUS, method: .get, encoding: JSONEncoding.default, headers: BEARER_HEADER()).responseObject { (response: DataResponse<SubscriptionRes>) in
            completion(response)
        }
    }
    
    func addCard(params: [String: Any], completion: @escaping ( _ response: DataResponse<NoDataRes>) -> Void) -> Void {
        Alamofire.request(URL_CARD_ADD, method: .post, parameters: params, encoding: JSONEncoding.default, headers: BEARER_HEADER()).responseObject { (response: DataResponse<NoDataRes>) in
            completion(response)
        }
    }
    
    func getBillingHistory(completion: @escaping ( _ response: DataResponse<InvoiceRes>) -> Void) -> Void {
        Alamofire.request(URL_BILLING_HISTORY, method: .get, encoding: JSONEncoding.default, headers: BEARER_HEADER()).responseObject { (response: DataResponse<InvoiceRes>) in
            completion(response)
        }
    }
    
    func cancelSubscription(completion: @escaping ( _ response: DataResponse<SubscriptionRes>) -> Void) -> Void {
        Alamofire.request(URL_SUBSCRIPTION_CANCEL, method: .get, encoding: JSONEncoding.default, headers: BEARER_HEADER()).responseObject { (response: DataResponse<SubscriptionRes>) in
            completion(response)
        }
    }
    
    func resumeSubscription(completion: @escaping ( _ response: DataResponse<SubscriptionRes>) -> Void) -> Void {
        Alamofire.request(URL_SUBSCRIPTION_RESUME, method: .get, encoding: JSONEncoding.default, headers: BEARER_HEADER()).responseObject { (response: DataResponse<SubscriptionRes>) in
            completion(response)
        }
    }
    
    func getAllRecentCall(completion: @escaping ( _ response: DataResponse<RecentCallRes>) -> Void) -> Void {
        Alamofire.request(URL_RECENT_CALL_GET, method: .get, encoding: JSONEncoding.default, headers: BEARER_HEADER()).responseObject { (response: DataResponse<RecentCallRes>) in
            completion(response)
        }
    }
    
    func getAllSchedule(completion: @escaping ( _ response: DataResponse<ScheduleAllRes>) -> Void) -> Void {
        Alamofire.request(URL_SCHEDULE_GET, method: .get, encoding: JSONEncoding.default, headers: BEARER_HEADER()).responseObject { (response: DataResponse<ScheduleAllRes>) in
            completion(response)
        }
    }
    
    func getAllContact(completion: @escaping ( _ response: DataResponse<ContactAllRes>) -> Void) -> Void {
        Alamofire.request(URL_CONTACT_GET, method: .get, encoding: JSONEncoding.default, headers: BEARER_HEADER()).responseObject { (response: DataResponse<ContactAllRes>) in
            completion(response)
        }
    }
    
    func addSchedule(params: [String: Any], completion: @escaping ( _ response: DataResponse<ScheduleAddRes>) -> Void) -> Void {
        Alamofire.request(URL_SCHEDULE_ADD, method: .post, parameters: params, encoding: JSONEncoding.default, headers: BEARER_HEADER()).responseObject { (response: DataResponse<ScheduleAddRes>) in
            completion(response)
        }
    }
}
