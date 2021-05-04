//
//  SubscriptionRes.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 28/04/2021.
//

import Foundation

struct SubscriptionRes : Codable {
    let success : Bool?
    let message : String?
    let data : Data?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
    }
    
    struct Data: Codable {
        let is_ended: Bool?
        let is_cancelled: Bool?
        let upcoming_invoice: Int64?
        
        enum CodingKeys: String, CodingKey {
            case is_ended = "is_ended"
            case is_cancelled = "is_cancelled"
            case upcoming_invoice = "upcoming_invoice"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            is_ended = try values.decodeIfPresent(Bool.self, forKey: .is_ended)
            is_cancelled = try values.decodeIfPresent(Bool.self, forKey: .is_cancelled)
            upcoming_invoice = try values.decodeIfPresent(Int64.self, forKey: .upcoming_invoice)
        }
    }
}

