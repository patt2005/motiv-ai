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
    
    struct ApiResponse: Decodable {
        let results: [Quote]
    }
    
    struct AuthoerInfoResponse: Decodable {
        let results: [AuthorInfo]
    }
    
    func fetchQuotes() async -> [Quote] {
        let url = URL(string: "http://api.quotable.io/quotes/random?limit=100&page=\(AppProvider.shared.page)")!
        
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
    
    func fetchQuotesByTagName(_ tagName: String) async -> [Quote] {
        let url = URL(string: "http://api.quotable.io/quotes?tags=\(tagName)&limit=200")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoded = try JSONDecoder().decode(ApiResponse.self, from: data)
            
            return decoded.results
        } catch {
            print("\(error.localizedDescription)")
            return []
        }
    }
    
    func fetchQuotesByAuthor(_ authorName: String) async -> [Quote] {
        let url = URL(string: "http://api.quotable.io/quotes?author=\(authorName)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoded = try JSONDecoder().decode(ApiResponse.self, from: data)
            
            return decoded.results
        } catch {
            print("\(error.localizedDescription)")
            return []
        }
    }
    
    func fetchAuthors() async -> [AuthorInfo] {
        let url = URL(string: "http://api.quotable.io/authors?sortBy=quoteCount&limit=150")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoded = try JSONDecoder().decode(AuthoerInfoResponse.self, from: data)
            
            return decoded.results
        } catch {
            print("\(error.localizedDescription)")
            return []
        }
    }
    
    func fetchCategories() async -> [QuoteCategory] {
        guard let url = URL(string: "http://api.quotable.io/tags?sortBy=quoteCount") else { return [] }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoded = try JSONDecoder().decode([QuoteCategory].self, from: data)
            
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
            
            let decoded = try JSONDecoder().decode(SearchQuoteResponse.self, from: data)
            
            return decoded.results
        } catch {
            print("\(error.localizedDescription)")
            return []
        }
    }
}
