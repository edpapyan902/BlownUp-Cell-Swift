//
//  InvoiceRes.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 03/05/2021.
//

import Foundation

struct InvoiceRes : Codable {
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
        let invoices: Invoices?
        
        enum CodingKeys: String, CodingKey {
            case invoices = "invoices"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            invoices = try values.decodeIfPresent(Invoices.self, forKey: .invoices)
        }
    }
    
    struct Invoices: Codable {
        let object: String?
        let data: [Invoice]?
        
        enum CodingKeys: String, CodingKey {
            case object = "object"
            case data = "data"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            object = try values.decodeIfPresent(String.self, forKey: .object)
            data = try values.decodeIfPresent([Invoice].self, forKey: .data)
        }
    }
}
