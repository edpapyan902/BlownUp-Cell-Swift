//
//  CreditCardRes.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 15/05/2021.
//

import Foundation

struct CreditCardRes: Codable {
    let success : Bool
    let message : String
    let data : Data

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)!
        message = try values.decodeIfPresent(String.self, forKey: .message)!
        data = try values.decodeIfPresent(Data.self, forKey: .data)!
    }
    
    struct Data: Codable {
        let card: CreditCard?
        
        enum CodingKeys: String, CodingKey {
            case card = "card"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            card = try values.decodeIfPresent(CreditCard.self, forKey: .card)
        }
    }
}
