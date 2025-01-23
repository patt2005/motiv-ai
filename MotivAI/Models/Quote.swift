//
//  Quote.swift
//  MotivAI
//
//  Created by Petru Grigor on 15.01.2025.
//

import Foundation

class Quote: Codable, Identifiable, ObservableObject {
    let id: String
    let content: String
    let author: String
    @Published var isLiked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case content, author, isLiked, _id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decode(String.self, forKey: .content)
        self.author = try container.decode(String.self, forKey: .author)
        self.isLiked = try container.decodeIfPresent(Bool.self, forKey: .isLiked) ?? false
        self.id = try container.decode(String.self, forKey: ._id)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
        try container.encode(author, forKey: .author)
        try container.encode(isLiked, forKey: .isLiked)
        try container.encode(id, forKey: ._id)
    }
}
