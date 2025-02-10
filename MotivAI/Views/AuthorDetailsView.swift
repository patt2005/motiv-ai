//
//  AuthorDetailsView.swift
//  MotivAI
//
//  Created by Petru Grigor on 05.02.2025.
//

import SwiftUI
import SuperwallKit

struct AuthorDetailsView: View {
    let author: AuthorInfo
    
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    @State private var isExpanded = false
    
    @State private var authorsQuotes: [Quote] = []
    
    @ObservedObject private var appProvider = AppProvider.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 13) {
                Text(author.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(AppConstants.shared.textColor)
                    .padding(.horizontal)
                
                if !author.description.isEmpty {
                    Text(author.description)
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                }
                
                Text("\(author.quoteCount) Quotes")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .onAppear {
                        Task { @MainActor in
                            authorsQuotes = await QuotesAPI.shared.fetchQuotesByAuthor(author.name)
                        }
                    }
                
                Divider()
                
                if !author.bio.isEmpty {
                    VStack(alignment: .leading) {
                        Text(author.bio)
                            .font(.body)
                            .foregroundColor(.gray)
                            .lineLimit(isExpanded ? nil : 3)
                            .padding(.horizontal)
                        
                        Button(action: {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }) {
                            Text(isExpanded ? "Show Less" : "Read More")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black.opacity(0.6))
                                .padding(.horizontal)
                        }
                    }
                }
                
                LazyVStack(spacing: 15) {
                    ForEach(authorsQuotes) { quote in
                        Button(action: {
                            if appProvider.isUserSubscribed {
                                impactFeedback.impactOccurred()
                                appProvider.selectedQuote = quote
                                appProvider.showQuoteDetails = true
                            } else {
                                Superwall.shared.register(event: "campaign_trigger")
                            }
                        }) {
                            QuoteCardView(quote: quote, feedback: impactFeedback)
                                .padding(.horizontal, 16)
                                .blur(radius: appProvider.isUserSubscribed ? 0 : 5)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(author.name)
        .background(AppConstants.shared.backgroundColor.ignoresSafeArea())
    }
}
