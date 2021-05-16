//
//  AccountUpdateRes.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 15/05/2021.
//

import Foundation

struct AccountUpdateRes: Codable {
    let password_success : Bool
    let spoof_phone_success : Bool
    let card_success : Bool
    let message : String
    let data : Data

    enum CodingKeys: String, CodingKey {
        case password_success = "password_success"
        case spoof_phone_success = "spoof_phone_success"
        case card_success = "card_success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        password_success = try values.decodeIfPresent(Bool.self, forKey: .password_success)!
        spoof_phone_success = try values.decodeIfPresent(Bool.self, forKey: .spoof_phone_success)!
        card_success = try values.decodeIfPresent(Bool.self, forKey: .card_success)!
        message = try values.decodeIfPresent(String.self, forKey: .message)!
        data = try values.decodeIfPresent(Data.self, forKey: .data)!
    }
    
    struct Data: Codable {
        let card : CreditCard?
        let is_ended: Bool?
        let is_cancelled: Bool?
        let upcoming_invoice: Int64?
        
        let user : User?
        let user_access_token : String?
        
        enum CodingKeys: String, CodingKey {
            case card = "card"
            case is_ended = "is_ended"
            case is_cancelled = "is_cancelled"
            case upcoming_invoice = "upcoming_invoice"
            
            case user = "user"
            case user_access_token = "user_access_token"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            card = try values.decodeIfPresent(CreditCard.self, forKey: .card)
            is_ended = try values.decodeIfPresent(Bool.self, forKey: .is_ended)
            is_cancelled = try values.decodeIfPresent(Bool.self, forKey: .is_cancelled)
            upcoming_invoice = try values.decodeIfPresent(Int64.self, forKey: .upcoming_invoice)
            
            user = try values.decodeIfPresent(User.self, forKey: .user)
            user_access_token = try values.decodeIfPresent(String.self, forKey: .user_access_token)
        }
    }
}
