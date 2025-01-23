//
//  QuoteCardView.swift
//  MotivAI
//
//  Created by Petru Grigor on 21.01.2025.
//

import SwiftUI

struct QuoteCardView: View {
    @ObservedObject var quote: Quote
    
    init(quote: Quote) {
        self.quote = quote
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("“\(quote.content)”")
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Text("- \(quote.author)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .italic()
            
            HStack {
                Spacer()
                Button(action: {
                    if quote.isLiked {
                        AppProvider.shared.removeQuoteFromLiked(quote)
                    } else {
                        AppProvider.shared.addQuoteToLiked(quote)
                    }
                }) {
                    Image(systemName: quote.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(quote.isLiked ? .red : .gray)
                        .font(.system(size: 22))
                }
            }
        }
        .padding(15)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 3))
    }
}
