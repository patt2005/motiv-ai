//
//  MotivAIApp.swift
//  MotivAI
//
//  Created by Petru Grigor on 15.01.2025.
//

import SwiftUI
import Firebase
import SuperwallKit
import RevenueCat

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: AppConstants.shared.revenueCatApiKey)
        
        FirebaseApp.configure()
        
        Superwall.configure(apiKey: AppConstants.shared.superWallApiKey)
        
        purchaseController.syncSubscriptionStatus()
        
        return true
    }
}

@main
struct MotivAIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
