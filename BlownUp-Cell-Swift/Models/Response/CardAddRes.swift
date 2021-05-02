//
//  CardAddRes.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 02/05/2021.
//

import Foundation

struct CardAddRes : Codable {
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
        let is_subscribed: Bool?
        let is_ended: Bool?
        let is_cancelled: Bool?
        let upcoming_invoice: Int?
        
        enum CodingKeys: String, CodingKey {
            case is_subscribed = "is_subscribed"
            case is_ended = "is_ended"
            case is_cancelled = "is_cancelled"
            case upcoming_invoice = "upcoming_invoice"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            is_subscribed = try values.decodeIfPresent(Bool.self, forKey: .is_subscribed)
            is_ended = try values.decodeIfPresent(Bool.self, forKey: .is_ended)
            is_cancelled = try values.decodeIfPresent(Bool.self, forKey: .is_cancelled)
            upcoming_invoice = try values.decodeIfPresent(Int.self, forKey: .upcoming_invoice)
        }
    }
}
