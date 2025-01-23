//
//  HomeView.swift
//  MotivAI
//
//  Created by Petru Grigor on 15.01.2025.
//

import SwiftUI
import SuperwallKit

class HomeViewModel: ObservableObject {
    @Published var isSharing: Bool = false
    @Published var selectedQuote: Quote?
}

struct HomeView: View {
    @State private var currentIndex = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    @ObservedObject private var appProvider = AppProvider.shared
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    ForEach(appProvider.quotes, id: \.content) { quote in
                        VStack(spacing: 0) {
                            QuoteView(quote: quote, feedback: impactFeedback, isSharing: $viewModel.isSharing, selectedQuote: $viewModel.selectedQuote)
                        }
                        .padding(.horizontal, 35)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .background(AppConstants.shared.backgroundColor)
                    }
                }
                .offset(y: -CGFloat(currentIndex) * geometry.size.height + dragOffset)
                .animation(.interpolatingSpring(stiffness: 150, damping: 50), value: currentIndex)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation.height
                        }
                        .onEnded { value in
                            let threshold = geometry.size.height / 40
                            let dragAmount = value.translation.height
                            
                            if dragAmount < -threshold && currentIndex < appProvider.quotes.count - 1 {
                                currentIndex += 1
                            } else if dragAmount > threshold && currentIndex > 0 {
                                currentIndex -= 1
                            }
                        }
                )
                .onAppear {
                    impactFeedback.prepare()
                }
            }
            .sheet(isPresented: $viewModel.isSharing) {
                ActivityView(activityItems: [
                    "\(viewModel.selectedQuote?.content ?? "") - \(viewModel.selectedQuote?.author ?? "")"])
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        impactFeedback.impactOccurred()
                        appProvider.navigationPath.append(.settingsView)
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .fill(AppConstants.shared.accentColor.opacity(0.9))
                                .frame(width: 47.5, height: 47.5)
                                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
                            
                            Image(systemName: "gearshape.fill")
                                .foregroundStyle(.white)
                                .font(.system(size: 23, weight: .medium))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 55)
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                HStack(alignment: .center) {
                    Button(action: {
                        appProvider.navigationPath.append(.searchView)
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .fill(AppConstants.shared.accentColor.opacity(0.9))
                                .frame(width: 47.5, height: 47.5)
                                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.white)
                                .font(.system(size: 23, weight: .medium))
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 15) {
                        if !appProvider.isUserSubscribed {
                            Button(action: {
                                Superwall.shared.register(event: "campaign_trigger")
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                                        .fill(AppConstants.shared.accentColor.opacity(0.9))
                                        .frame(width: 47.5, height: 47.5)
                                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
                                    
                                    Image(systemName: "crown.fill")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 23, weight: .medium))
                                }
                            }
                        }
                        
                        Button(action: {
                            impactFeedback.impactOccurred()
                            appProvider.navigationPath.append(.likedQuotesView)
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 13, style: .continuous)
                                    .fill(AppConstants.shared.accentColor.opacity(0.9))
                                    .frame(width: 47.5, height: 47.5)
                                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
                                
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 23, weight: .medium))
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .edgesIgnoringSafeArea(.all)
        .preferredColorScheme(.light)
        .background(AppConstants.shared.backgroundColor)
    }
}
