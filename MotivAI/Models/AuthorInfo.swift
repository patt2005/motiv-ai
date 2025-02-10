//
//  AuthorInfo.swift
//  MotivAI
//
//  Created by Petru Grigor on 04.02.2025.
//

import Foundation

class AuthorInfo: Decodable, Equatable, Hashable {
    let id: String
    let name: String
    let bio: String
    let description: String
    let quoteCount: Int
    
    static func == (lhs: AuthorInfo, rhs: AuthorInfo) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case _id, name, bio, description, quoteCount
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.bio = try container.decode(String.self, forKey: .bio)
        self.description = try container.decode(String.self, forKey: .description)
        self.quoteCount = try container.decode(Int.self, forKey: .quoteCount)
        self.id = try container.decode(String.self, forKey: ._id)
    }
}
