//
//  QuoteCategory.swift
//  MotivAI
//
//  Created by Petru Grigor on 04.02.2025.
//

import Foundation

class QuoteCategory: Decodable {
    let id: String
    let name: String
    let quoteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case quoteCount, name, _id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.quoteCount = try container.decode(Int.self, forKey: .quoteCount)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(String.self, forKey: ._id)
    }
}
