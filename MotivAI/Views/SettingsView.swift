//
//  SettingsView.swift
//  MotivAI
//
//  Created by Petru Grigor on 21.01.2025.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var isSharing = false
    @Environment(\.requestReview) var requestReview

    var body: some View {
        ZStack {
            AppConstants.shared.backgroundColor
                .edgesIgnoringSafeArea(.all)

            Form {
                Section(header: Text("Feedback")) {
                    Button(action: {
                        isSharing = true
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(AppConstants.shared.accentColor)
                                .font(.title2)
                            Text("Share App")
                                .foregroundColor(.gray)
                                .padding(.leading, 8.5)
                        }
                    }
                    
                    Button(action: {
                        let email = "mihai@codbun.com"
                        let subject = "Support Request"
                        let body = "Hi, I need help with..."
                        let mailtoURL = "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                        
                        if let url = URL(string: mailtoURL) {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            } else {
                                print("Mail app is not available")
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(AppConstants.shared.accentColor)
                                .font(.title2)
                            Text("Contact us")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Button(action: {
                        requestReview()
                    }) {
                        HStack {
                            Image(systemName: "hand.thumbsup")
                                .foregroundColor(AppConstants.shared.accentColor)
                                .font(.title2)
                            Text("Rate us")
                                .foregroundColor(.gray)
                                .padding(.leading, 5)
                        }
                    }
                }
                
                Section(header: Text("Legal")) {
                    Link(destination: URL(string: "https://codbun.com/chatai/privacypolicy")!) {
                        HStack {
                            Image(systemName: "lock.shield")
                                .foregroundColor(AppConstants.shared.accentColor)
                                .font(.title2)
                            Text("Privacy Policy")
                                .foregroundColor(.gray)
                        }
                    }

                    Link(destination: URL(string: "https://codbun.com/chatai/termsofuse")!) {
                        HStack {
                            Image(systemName: "doc.text")
                                .foregroundColor(AppConstants.shared.accentColor)
                                .font(.title2)
                            Text("Terms of Use")
                                .foregroundColor(.gray)
                        }
                    }
                }

                Section(header: Text("About Us")) {
                    Link(destination: URL(string: "https://codbun.com/About")!) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(AppConstants.shared.accentColor)
                                .font(.title2)
                            Text("About us")
                                .foregroundColor(.gray)
                        }
                    }

                    Link(destination: URL(string: "https://codbun.com/Work")!) {
                        HStack {
                            Image(systemName: "app.badge")
                                .foregroundColor(AppConstants.shared.accentColor)
                                .font(.title2)
                            Text("Our Apps")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .sheet(isPresented: $isSharing) {
            ActivityView(activityItems: [
                "https://apps.apple.com/us/app/meme-ai-meme-coin-tracker-app/id6738891806"])
        }
        .navigationTitle(Text("Settings"))
    }
}
