//
//  ContentView.swift
//  MotivAI
//
//  Created by Petru Grigor on 15.01.2025.
//

import SwiftUI
import Combine

class ContentViewModel: ObservableObject {
    @Published var selectedTab = 0
    
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $selectedTab
            .sink { newTab in
                self.impactFeedback.prepare()
                self.impactFeedback.impactOccurred()
            }
            .store(in: &cancellables)
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    @ObservedObject private var appProvider = AppProvider.shared
    
    var body: some View {
        NavigationStack(path: $appProvider.navigationPath) {
            HomeView()
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .likedQuotesView: LikedListView()
                    case .settingsView: SettingsView()
                    case .searchView: SearchView()
                    case .categoriesView: QuoteCategoryListView()
                    case .quotesListView(let tagName) : QuotesListView(tagName: tagName)
                    case .authorsListView: AuthorsListView()
                    case .authorDetailsView(authorInfo: let details): AuthorDetailsView(author: details)
                    case .manageSubscriptionView: ManageSubscriptionView()
                    case .restoreView : RestoreView()
                    }
                }
                .fullScreenCover(isPresented: $appProvider.showOnboarding) {
                    OnboardingView()
                }
                .fullScreenCover(isPresented: $appProvider.showInfoOnboarding) {
                    InfoOnboardingView()
                }
                .sheet(isPresented: $appProvider.showQuoteDetails) {
                    QuoteDetailsView()
                }
        }
        .preferredColorScheme(.light)
        .background(AppConstants.shared.backgroundColor)
    }
}

class HostingController: UIHostingController<ContentView> {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
