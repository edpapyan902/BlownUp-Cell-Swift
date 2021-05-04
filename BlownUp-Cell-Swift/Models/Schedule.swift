//
//  Schedule.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 04/05/2021.
//

import Foundation

struct Schedule: Codable {
    let id : Int
    let number : String
    let scheduled_at : Int64
    let alarm_identify : String
    var contact : Contact?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case number = "number"
        case scheduled_at = "scheduled_at"
        case alarm_identify = "alarm_identify"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)!
        number = try values.decodeIfPresent(String.self, forKey: .number)!
        scheduled_at = try values.decodeIfPresent(Int64.self, forKey: .scheduled_at)!
        alarm_identify = try values.decodeIfPresent(String.self, forKey: .alarm_identify)!
    }
}
