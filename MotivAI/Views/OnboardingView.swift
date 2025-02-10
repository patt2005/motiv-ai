//
//  OnboardingView.swift
//  MotivAI
//
//  Created by Petru Grigor on 21.01.2025.
//

import SwiftUI
import FirebaseAnalytics

struct OnboardingView: View {
    struct OnboardingStep {
        let image: String
        let title: String
        let description: String
    }
    
    private let onboardingSteps: [OnboardingStep] = [
        OnboardingStep(
            image: "1",
            title: "Get Inspired Every Day",
            description: "Start your day with a powerful quote! Receive daily motivational quotes to uplift and energize you."
        ),
        OnboardingStep(
            image: "2",
            title: "Personalized Just for You",
            description: "Choose your favorite topics and get handpicked quotes that match your mood and goals."
        ),
        OnboardingStep(
            image: "3",
            title: "Stay Motivated & Achieve More",
            description: "Bookmark your favorite quotes, set reminders, and keep yourself motivated every step of the way!"
        ),
        OnboardingStep(
            image: "4",
            title: "Your Opinion Matters",
            description: "Help us grow by leaving a positive rating. Your feedback means the world to us!"
        ),
    ]
    
    @Environment(\.requestReview) var requestReview
    @State private var hasRequestedReview: Bool = false
    
    @ObservedObject private var appProvider = AppProvider.shared
    
    @State private var currentStep: Int = 0
    
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            currentStep = onboardingSteps.count - 1
                        }
                    }) {
                        Text("Skip")
                            .padding(16)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .onAppear {
                impactFeedback.prepare()
                AnalyticsManager.shared.logEvent(name: AnalyticsEventTutorialBegin)
            }
            
            TabView(selection: $currentStep) {
                ForEach(0..<onboardingSteps.count, id: \.self) { index in
                    VStack {
                        Image(onboardingSteps[index].image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                        
                        Text(onboardingSteps[index].title)
                            .font(.title2.bold())
                            .foregroundColor(AppConstants.shared.accentColor)
                            .multilineTextAlignment(.center)
                            .padding(.vertical)
                        
                        Text(onboardingSteps[index].description)
                            .font(Font.custom("Inter", size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 30)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack {
                ForEach(0..<onboardingSteps.count, id: \.self) { index in
                    if index == currentStep {
                        Circle()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(AppConstants.shared.accentColor)
                    } else {
                        Circle()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(Color(hex: "#2F2F30"))
                    }
                }
            }
            .padding(.top, 40)
            .padding(.bottom, 80)
            
            Button(action: {
                impactFeedback.impactOccurred()
                if currentStep < onboardingSteps.count - 2 {
                    withAnimation {
                        currentStep += 1
                    }
                } else if currentStep == onboardingSteps.count - 2 {
                    withAnimation {
                        currentStep += 1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        hasRequestedReview = true
                        requestReview()
                    }
                } else {
                    withAnimation {
                        if !hasRequestedReview {
                            requestReview()
                        }
                        appProvider.showOnboarding = false
                        appProvider.showInfoOnboarding = true
                    }
                }
            }) {
                ZStack {
                    HStack {
                        Text(currentStep == onboardingSteps.count - 1 ? "Get Started" : "Continue")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(AppConstants.shared.secondaryColor)
                    .cornerRadius(28)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                    
                    HStack {
                        Spacer()
                        ZStack {
                            Rectangle()
                                .foregroundColor(.green.opacity(0.4))
                                .frame(width: 35, height: 35)
                                .cornerRadius(17.5)
                            
                            Image(systemName: "arrow.forward")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .foregroundStyle(.white)
                        }
                        .padding(.bottom, 20)
                        .padding(.trailing, 28)
                    }
                }
            }
        }
        .background(.white)
    }
}
