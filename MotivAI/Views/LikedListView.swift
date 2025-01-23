//
//  LikedListView.swift
//  MotivAI
//
//  Created by Petru Grigor on 21.01.2025.
//

import SwiftUI

struct LikedListView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    
    var body: some View {
        ScrollView {
            if appProvider.likedQuotes.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "heart.slash.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.gray.opacity(0.6))
                    
                    Text("No Liked Quotes Yet")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black.opacity(0.8))
                    
                    Text("Tap the heart icon on a quote to save it here.")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                .padding(.top, 245)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                LazyVStack(spacing: 15) {
                    ForEach(appProvider.likedQuotes.reversed()) { quote in
                        QuoteCardView(quote: quote)
                            .padding(.horizontal, 16)
                    }
                }
                .padding(.top, 20)
            }
        }
        .navigationTitle(Text("Saved"))
        .background(AppConstants.shared.backgroundColor)
    }
}
