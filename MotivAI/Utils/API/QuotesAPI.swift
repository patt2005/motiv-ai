//
//  QuotesAPI.swift
//  MotivAI
//
//  Created by Petru Grigor on 15.01.2025.
//

import Foundation

class QuotesAPI {
    struct SearchQuoteResponse: Decodable {
        let results: [Quote]
    }
    
    private init() {}
    
    static let shared = QuotesAPI()
    
    func fetchQuotes() async -> [Quote] {
        guard let url = URL(string: "http://api.quotable.io/quotes/random?limit=100") else { return [] }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoded = try JSONDecoder().decode([Quote].self, from: data)
            
            return decoded
        } catch {
            print("\(error.localizedDescription)")
            return []
        }
    }
    
    func searchQuotes(_ query: String) async -> [Quote] {
        guard let url = URL(string: "http://api.quotable.io/search/quotes?query=\(query)&fields=content,author,tags&fuzzyMaxEdits=1") else { return [] }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            print(String(data: data, encoding: .utf8) ?? "")
            
            let decoded = try JSONDecoder().decode(SearchQuoteResponse.self, from: data)
            
            return decoded.results
        } catch {
            print("\(error.localizedDescription)")
            return []
        }
    }
}
