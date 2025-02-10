//
//  QuoteDetailsView.swift
//  MotivAI
//
//  Created by Petru Grigor on 03.02.2025.
//

import SwiftUI
import SuperwallKit

struct QuoteDetailsView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    
    let feedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("“\(appProvider.selectedQuote?.content ?? "No quote available")”")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if let author = appProvider.selectedQuote?.author {
                Text("- \(author)")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
                    .onAppear {
                        feedback.prepare()
                    }
            }
            
            Spacer()
            
            if let quote = appProvider.selectedQuote {
                HStack(spacing: 30) {
                    Button(action: {
                        feedback.impactOccurred()
                        if quote.isLiked {
                            AppProvider.shared.removeQuoteFromLiked(quote)
                        } else {
                            AppProvider.shared.addQuoteToLiked(quote)
                        }
                    }) {
                        Image(systemName: quote.isLiked ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .font(.title)
                    }
                    
                    Button(action: {
                        feedback.impactOccurred()
                        appProvider.showQuoteDetails = false
                        appProvider.selectedQuote = quote
                        appProvider.isSharingQuote = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.blue)
                            .font(.title)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppConstants.shared.backgroundColor)
    }
}
