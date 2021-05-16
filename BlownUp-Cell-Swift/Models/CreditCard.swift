//
//  File.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 15/05/2021.
//

import Foundation

struct CreditCard: Codable {
    let id : Int
    let card_number : String
    let card_expire_year : Int
    let card_expire_month : Int
    let card_cvv : String
    let card_zip_code : String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case card_number = "card_number"
        case card_expire_year = "card_expire_year"
        case card_expire_month = "card_expire_month"
        case card_cvv = "card_cvv"
        case card_zip_code = "card_zip_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)!
        card_number = try values.decodeIfPresent(String.self, forKey: .card_number)!
        card_expire_year = try values.decodeIfPresent(Int.self, forKey: .card_expire_year)!
        card_expire_month = try values.decodeIfPresent(Int.self, forKey: .card_expire_month)!
        card_cvv = try values.decodeIfPresent(String.self, forKey: .card_cvv)!
        card_zip_code = try values.decodeIfPresent(String.self, forKey: .card_zip_code)!
    }
}
