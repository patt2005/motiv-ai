//
//  AppProvider.swift
//  MotivAI
//
//  Created by Petru Grigor on 15.01.2025.
//

import Foundation
import FirebaseAnalytics
import SuperwallKit

class AppProvider: ObservableObject {
    private init() {
        self.showOnboarding = !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        DispatchQueue.main.async {
            Task {
                self.quotes = await QuotesAPI.shared.fetchQuotes()
                self.quoteCategories = await QuotesAPI.shared.fetchCategories()
                self.authors = await QuotesAPI.shared.fetchAuthors()
            }
        }
        loadLikedQuotes()
        AnalyticsManager.shared.setUserProperty(value: self.isUserSubscribed.description, property: "isPremiumUser")
    }
    
    static let shared: AppProvider = AppProvider()
    
    @Published var navigationPath: [NavigationDestination] = []
    
    @Published var showOnboarding = false
    @Published var showInfoOnboarding = false
    @Published var isSharingQuote: Bool = false
    
    @Published var authors: [AuthorInfo] = []
    
    @Published var quoteCategories: [QuoteCategory] = []
    
    @Published var quotes = [Quote]()
    @Published var likedQuotes = [Quote]()
    
    @Published var isUserSubscribed = true
    
    @Published var showQuoteDetails = false
    @Published var selectedQuote: Quote?
    
    @Published var page: Int = 1
    
    func completeOnboarding() {
        AnalyticsManager.shared.logEvent(name: AnalyticsEventTutorialComplete)
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        self.showInfoOnboarding = false
    }
    
    func saveLikedQuotes() {
        do {
            let encodedData = try JSONEncoder().encode(likedQuotes)
            UserDefaults.standard.set(encodedData, forKey: "likedQuotes")
        } catch {
            print("Failed to save liked quotes: \(error)")
        }
    }
    
    private func loadLikedQuotes() {
        let data = UserDefaults.standard.data(forKey: "likedQuotes")
        if let data = data {
            do {
                let decoded = try JSONDecoder().decode([Quote].self, from: data)
                self.likedQuotes = decoded
            } catch {
                print("Falied to load liked quotes: \(error)")
            }
        }
    }
    
    func addQuoteToLiked(_ quote: Quote) {
        if isUserSubscribed || likedQuotes.count < 10 {
            likedQuotes.append(quote)
            quote.isLiked = true
            saveLikedQuotes()
        } else {
            Superwall.shared.register(event: "campaign_trigger")
        }
    }
    
    func removeQuoteFromLiked(_ quote: Quote) {
        likedQuotes.removeAll { $0.id == quote.id }
        quote.isLiked = false
        saveLikedQuotes()
    }
}
