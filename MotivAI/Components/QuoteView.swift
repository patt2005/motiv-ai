//
//  QuoteView.swift
//  MotivAI
//
//  Created by Petru Grigor on 15.01.2025.
//

import SwiftUI

struct QuoteView: View {
    let quote: Quote
    let feedback: UIImpactFeedbackGenerator
    
    @Binding var isSharing: Bool
    @Binding var selectedQuote: Quote?
    
    var body: some View {
        Text("\(quote.content)")
            .foregroundColor(AppConstants.shared.textColor)
            .font(.custom("PTSerif-Regular", size: 20))
            .multilineTextAlignment(.center)
            .padding(.bottom, 7)
            .textSelection(.enabled)
        
        Text(quote.author)
            .foregroundColor(AppConstants.shared.textColor)
            .font(.custom("PTSerif-Regular", size: 23).bold())
            .multilineTextAlignment(.center)
            .padding(.bottom, 30)
        
        HStack(alignment: .center, spacing: 35) {
            Button(action: {
                selectedQuote = quote
                feedback.impactOccurred()
                isSharing = true
            }) {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 31, height: 31)
                    .foregroundStyle(AppConstants.shared.secondaryColor)
            }
            
            Button(action: {
                feedback.impactOccurred()
                if quote.isLiked {
                    AppProvider.shared.removeQuoteFromLiked(quote)
                } else {
                    AppProvider.shared.addQuoteToLiked(quote)
                }
                
            }) {
                Image(systemName: quote.isLiked ? "heart.fill" : "heart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(.red)
            }
        }
    }
}
