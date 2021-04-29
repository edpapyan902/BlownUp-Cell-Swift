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
        Alamofire.request(URL_LOGIN, method: .post, parameters: params, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseObject { (response: DataResponse<LoginRes>) in
            completion(response)
        }
    }
    
    func signUp(params: [String: Any], completion: @escaping ( _ response: DataResponse<SignUpRes>) -> Void) -> Void {
        Alamofire.request(URL_SIGN_UP, method: .post, parameters: params, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseObject { (response: DataResponse<SignUpRes>) in
            completion(response)
        }
    }
    
    func getSubscriptionStatus(completion: @escaping ( _ response: DataResponse<SubscriptionRes>) -> Void) -> Void {
        Alamofire.request(URL_SUBSCRIPTION_STATUS, method: .get, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseObject { (response: DataResponse<SubscriptionRes>) in
            completion(response)
        }
    }
}
