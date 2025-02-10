//
//  QuotesListView.swift
//  MotivAI
//
//  Created by Petru Grigor on 04.02.2025.
//

import SwiftUI
import SuperwallKit

struct QuotesListView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    @State private var quotesList: [Quote] = []
    
    let tagName: String
    
    var body: some View {
        ScrollView {
            if quotesList.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        Task { @MainActor in
                            quotesList = await QuotesAPI.shared.fetchQuotesByTagName(tagName)
                        }
                    }
            } else {
                LazyVStack(spacing: 15) {
                    if appProvider.isUserSubscribed {
                        ForEach(quotesList) { quote in
                            Button(action: {
                                impactFeedback.impactOccurred()
                                appProvider.selectedQuote = quote
                                appProvider.showQuoteDetails = true
                            }) {
                                QuoteCardView(quote: quote, feedback: impactFeedback)
                                    .padding(.horizontal, 16)
                            }
                        }
                    } else {
                        ForEach(quotesList.prefix(5)) { quote in
                            Button(action: {
                                impactFeedback.impactOccurred()
                                appProvider.selectedQuote = quote
                                appProvider.showQuoteDetails = true
                            }) {
                                QuoteCardView(quote: quote, feedback: impactFeedback)
                                    .padding(.horizontal, 16)
                            }
                        }
                        ForEach(quotesList.dropFirst(5)) { quote in
                            Button(action: {
                                impactFeedback.impactOccurred()
                                Superwall.shared.register(event: "campaign_trigger")
                            }) {
                                QuoteCardView(quote: quote, feedback: impactFeedback)
                                    .padding(.horizontal, 16)
                                    .blur(radius: 5)
                            }
                        }
                    }
                }
                .padding(.top, 20)
            }
        }
        .navigationTitle(Text(tagName))
        .background(AppConstants.shared.backgroundColor)
    }
}
