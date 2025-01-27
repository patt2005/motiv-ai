//
//  AppProvider.swift
//  MotivAI
//
//  Created by Petru Grigor on 15.01.2025.
//

import Foundation
import FirebaseAnalytics
import RevenueCat

class AppProvider: ObservableObject {
    private init() {
        self.showOnboarding = !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
//        Purchases.shared.getCustomerInfo { (customerInfo, error) in
//            self.isUserSubscribed = customerInfo?.entitlements.all["pro"]?.isActive == true
//        }
        DispatchQueue.main.async {
            Task {
                self.quotes = await QuotesAPI.shared.fetchQuotes()
            }
        }
        loadLikedQuotes()
        AnalyticsManager.shared.setUserProperty(value: self.isUserSubscribed.description, property: "isPremiumUser")
    }
    
    static let shared: AppProvider = AppProvider()
    
    @Published var navigationPath: [NavigationDestination] = []
    
    @Published var showOnboarding = false
    
    @Published var quotes = [Quote]()
    @Published var likedQuotes = [Quote]()
    
    @Published var isUserSubscribed = true
    
    func completeOnboarding() {
        AnalyticsManager.shared.logEvent(name: AnalyticsEventTutorialComplete)
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        self.showOnboarding = false
    }
    
    func saveLikedQuotes() {
        do {
            let encodedData = try JSONEncoder().encode(likedQuotes)
            UserDefaults.standard.set(encodedData, forKey: "likedQuotes")
        } catch {
            print("Failed to save liked quotes: \(error)")
        }
    }
    
    func loadLikedQuotes() {
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
        likedQuotes.append(quote)
        quote.isLiked = true
        saveLikedQuotes()
    }
    
    func removeQuoteFromLiked(_ quote: Quote) {
        likedQuotes.removeAll { $0.id == quote.id }
        quote.isLiked = false
        saveLikedQuotes()
    }
}
