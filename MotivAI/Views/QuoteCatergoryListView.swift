//
//  QuoteCatergoryListView.swift
//  MotivAI
//
//  Created by Petru Grigor on 04.02.2025.
//

import SwiftUI

struct QuoteCategoryListView: View {
    @ObservedObject private var appProvider = AppProvider.shared
    
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(appProvider.quoteCategories, id: \.id) { category in
                    Button(action: {
                        impactFeedback.impactOccurred()
                        appProvider.navigationPath.append(.quotesListView(tagName: category.name))
                    }) {
                        QuoteCategoryCardView(category: category)
                            .padding(.horizontal, 16)
                    }
                }
            }
            .padding(.top, 20)
        }
        .navigationTitle("Categories")
        .background(AppConstants.shared.backgroundColor)
    }
}

struct QuoteCategoryCardView: View {
    let category: QuoteCategory
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("\(category.quoteCount) Quotes")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
