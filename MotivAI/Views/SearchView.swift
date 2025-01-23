//
//  SearchView.swift
//  MotivAI
//
//  Created by Petru Grigor on 21.01.2025.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var filteredQuotes: [Quote] = []
    
    @State private var isLoading: Bool = false
    
    @ObservedObject private var appProvider = AppProvider.shared
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search quotes...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 10)
                    .onChange(of: searchText) { newValue in
                        if !newValue.isEmpty {
                            Task {
                                isLoading = true
                                filteredQuotes = await QuotesAPI.shared.searchQuotes(newValue)
                                isLoading = false
                            }
                        }
                    }
            }
            .padding(.bottom, 1)
            .padding(.horizontal, 10)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black.opacity(0.3), lineWidth: 1.1)
            )
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 5)
            
            ScrollView {
                if isLoading {
                    VStack {
                        ProgressView()
                            .padding(.bottom, 10)
                        
                        Text("Loading...")
                            .foregroundStyle(.black)
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    LazyVStack(spacing: 15) {
                        ForEach(filteredQuotes.isEmpty ? appProvider.quotes : filteredQuotes) { quote in
                            QuoteCardView(quote: quote)
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 10)
                }
            }
        }
        .navigationTitle(Text("Search"))
        .background(AppConstants.shared.backgroundColor)
        .onAppear {
            filteredQuotes = appProvider.quotes
        }
    }
}
