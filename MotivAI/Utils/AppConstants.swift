//
//  AppConstants.swift
//  MotivAI
//
//  Created by Petru Grigor on 15.01.2025.
//

import Foundation
import SwiftUI

let purchaseController = RCPurchaseController()

class AppConstants {
    static let shared = AppConstants()
    
    private init() {
        userId = UserDefaults.standard.string(forKey: "userId")
    }
    
    let appCode = "motivation"
    let appVersion = "1.0.4"
    var userId: String? = nil
    
    let backgroundColor = Color(hex: "FBF5DD")
    let textColor = Color(hex: "16404D")
    let secondaryColor = Color(hex: "A6CDC6")
    let accentColor = Color(hex: "DDA853")
    
    let revenueCatApiKey = "appl_GSNCUVRGbpiNhnlDZXWjDVOgmog"
    let superWallApiKey = "pk_fd57c8cf0786d7b100e8f5c9bd5c7f68cf20dd4a22ff2a9a"
    
    func saveUserId(_ userId: String) {
        self.userId = userId
        UserDefaults.standard.set(userId, forKey: "userId")
    }
}

enum NavigationDestination: Hashable {
    case settingsView
    case likedQuotesView
    case searchView
    case categoriesView
    case quotesListView(tagName: String)
    case authorsListView
    case authorDetailsView(authorInfo: AuthorInfo)
    case restoreView
    case manageSubscriptionView
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

