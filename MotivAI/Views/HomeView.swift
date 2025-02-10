//
//  HomeView.swift
//  MotivAI
//
//  Created by Petru Grigor on 15.01.2025.
//

import SwiftUI
import Combine
import SuperwallKit

class HomeViewModel: ObservableObject {
    @Published var currentIndex = 0
    
    @ObservedObject private var appProvider = AppProvider.shared
    
    private var cancellables = Set<AnyCancellable>()
    private var isFetching = false
    
    init() {
        $currentIndex
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newIndex in
                guard let self = self else { return }
                appProvider.page += 1
                
                if newIndex >= self.appProvider.quotes.count - 90, !self.isFetching {
                    self.isFetching = true
                    Task {
                        let newQuotes = await QuotesAPI.shared.fetchQuotes()
                        DispatchQueue.main.async {
                            self.appProvider.quotes += newQuotes
                            self.isFetching = false
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}

struct HomeView: View {
    @GestureState private var dragOffset: CGFloat = 0
    
    @ObservedObject private var appProvider = AppProvider.shared
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    @StateObject private var viewModel = HomeViewModel()
    
    private var flippingAngle: Angle = .degrees(0)
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                TabView(selection: $viewModel.currentIndex) {
                    if appProvider.isUserSubscribed {
                        ForEach(0..<appProvider.quotes.count, id: \.self) { index in
                            QuoteView(quote: appProvider.quotes[index], feedback: impactFeedback, isBlured: false)
                                .padding(.leading, 35)
                                .padding(.trailing, 12.5)
                                .frame(width: proxy.size.width)
                                .frame(maxHeight: .infinity)
                                .rotationEffect(.degrees(-90))
                        }
                    } else {
                        if appProvider.quotes.count > 11 {
                            ForEach(0..<10, id: \.self) { index in
                                QuoteView(quote: appProvider.quotes[index], feedback: impactFeedback, isBlured: false)
                                    .padding(.leading, 35)
                                    .padding(.trailing, 12.5)
                                    .frame(width: proxy.size.width)
                                    .frame(maxHeight: .infinity)
                                    .rotationEffect(.degrees(-90))
                            }
                            ForEach(11..<appProvider.quotes.count, id: \.self) { index in
                                QuoteView(quote: appProvider.quotes[index], feedback: impactFeedback, isBlured: true)
                                    .padding(.leading, 35)
                                    .padding(.trailing, 12.5)
                                    .frame(width: proxy.size.width)
                                    .frame(maxHeight: .infinity)
                                    .rotationEffect(.degrees(-90))
                            }
                        }
                    }
                }
                .frame(width: proxy.size.height, height: proxy.size.width)
                .rotationEffect(.degrees(90), anchor: .topLeading)
                .offset(x: proxy.size.width)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear {
                impactFeedback.prepare()
            }
            .sheet(isPresented: $appProvider.isSharingQuote) {
                SharingView(activityItems: [
                    "\(appProvider.selectedQuote?.content ?? "") - \(appProvider.selectedQuote?.author ?? "")"])
            }
            
            VStack {
                HStack {
                    if !appProvider.isUserSubscribed {
                        Button(action: {
                            impactFeedback.impactOccurred()
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
                    HStack(spacing: 15) {
                        Button(action: {
                            impactFeedback.impactOccurred()
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
                        
                        Button(action: {
                            impactFeedback.impactOccurred()
                            appProvider.navigationPath.append(.categoriesView)
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 13, style: .continuous)
                                    .fill(AppConstants.shared.accentColor.opacity(0.9))
                                    .frame(width: 47.5, height: 47.5)
                                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
                                
                                Image(systemName: "square.grid.2x2.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 23, weight: .medium))
                            }
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            impactFeedback.impactOccurred()
                            appProvider.navigationPath.append(.authorsListView)
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 13, style: .continuous)
                                    .fill(AppConstants.shared.accentColor.opacity(0.9))
                                    .frame(width: 47.5, height: 47.5)
                                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
                                
                                Image(systemName: "person.2.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 23, weight: .medium))
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
