//
//  AuthorsListView.swift
//  MotivAI
//
//  Created by Petru Grigor on 05.02.2025.
//

import SwiftUI

struct AuthorsListView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(appProvider.authors, id: \.id) { author in
                    Button(action: {
                        impactFeedback.impactOccurred()
                        appProvider.navigationPath.append(.authorDetailsView(authorInfo: author))
                    }) {
                        AuthorCardView(author: author)
                            .padding(.horizontal, 16)
                    }
                }
            }
            .padding(.top, 20)
            .onAppear {
                impactFeedback.prepare()
            }
        }
        .navigationTitle("Authors")
        .background(AppConstants.shared.backgroundColor)
    }
}

struct AuthorCardView: View {
    let author: AuthorInfo
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(author.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppConstants.shared.textColor)
                
                Text("\(author.quoteCount) Quotes")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if !author.description.isEmpty {
                    Text(author.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
