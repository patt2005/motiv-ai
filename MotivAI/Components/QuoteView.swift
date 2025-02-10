//
//  QuoteView.swift
//  MotivAI
//
//  Created by Petru Grigor on 15.01.2025.
//

import SwiftUI
import SuperwallKit

struct QuoteView: View {
    let quote: Quote
    let feedback: UIImpactFeedbackGenerator
    let isBlured: Bool
    
    @ObservedObject private var appProvider = AppProvider.shared
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if isBlured {
                Text("“\(quote.content)”")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .textSelection(.disabled)
                    .padding(.bottom, 7)
                    .blur(radius: 5)
            } else {
                Text("“\(quote.content)”")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .textSelection(.enabled)
                    .padding(.bottom, 7)
            }
            
            Text(quote.author)
                .foregroundColor(AppConstants.shared.textColor)
                .font(.custom("PTSerif-Regular", size: 22))
                .multilineTextAlignment(.center)
                .padding(.bottom, 30)
                .blur(radius: isBlured ? 5 : 0)
            
            HStack(alignment: .center, spacing: 35) {
                Button(action: {
                    feedback.impactOccurred()
                    if !isBlured {
                        appProvider.selectedQuote = quote
                        appProvider.isSharingQuote.toggle()
                    } else {
                        Superwall.shared.register(event: "campaign_trigger")
                    }
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 31, height: 31)
                        .foregroundColor(.blue)
                        .blur(radius: isBlured ? 5 : 0)
                }
                
                Button(action: {
                    feedback.impactOccurred()
                    if !isBlured {
                        if quote.isLiked {
                            appProvider.removeQuoteFromLiked(quote)
                        } else {
                            appProvider.addQuoteToLiked(quote)
                        }
                    } else {
                        Superwall.shared.register(event: "campaign_trigger")
                    }
                }) {
                    Image(systemName: quote.isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundStyle(.red)
                        .blur(radius: isBlured ? 5 : 0)
                }
            }
        }
    }
}
