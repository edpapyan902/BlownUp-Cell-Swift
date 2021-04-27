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
    
    func login(email: String, password: String, completion: @escaping ( _ response: DataResponse<LoginRes>) -> Void) -> Void {
        let params: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: params, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseObject { (response: DataResponse<LoginRes>) in
            completion(response)
        }
    }
}
