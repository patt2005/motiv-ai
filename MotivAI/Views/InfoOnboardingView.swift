//
//  InfoOnboardingView.swift
//  MotivAI
//
//  Created by Petru Grigor on 03.02.2025.
//

import SwiftUI
import UIKit
import SuperwallKit

struct InfoOnboardingView: View {
    let paramsList: [InfoOnboarding] = [InfoOnboarding(title: "How did you hear about us?", description: "Select an option to continue", parameter: "trafficSource", options: ["TikTok", "Instagram", "Facebook", "AppStore", "Web search", "Friend/Family", "Other"]), InfoOnboarding(title: "Are you religious?", description: "This information will be used to tailor your quotes to your beliefs", parameter: "religious", options: ["Yes", "No", "Spiritual but not religious"]), InfoOnboarding(title: "Which option represents you best?", description: "This information will be used to personalize your quotes", parameter: "gender", options: ["Female", "Male", "Other", "Prefer not to say"]), InfoOnboarding(title: "How old are you?", description: "Your age is used to personalize your content", parameter: "age", options: ["13 to 17", "18 to 24", "25 to 34", "35 to 44", "45 to 54", "55+"]), InfoOnboarding(title: "What's your relationship status?", description: "You'll see quotes that fit your current situation", parameter: "relationshipStatus", options: ["In a happy relationship", "In a challenging relationship", "Happily single", "Single and open to connection", "Recently out of a relationship", "Prefer not to say"]), InfoOnboarding(title: "Which of this describes best your beliefs?", description: "This information will be used to personalize your quotes to your beliefs", parameter: "beliefs", options: ["Christianity", "Islam", "Judaism", "Hinduism", "Buddhism", "Atheism/Agnosticism", "Other"]), InfoOnboarding(title: "What do you want to be called?", description: "Your name will be displayed on your quotes", parameter: "name", options: []), InfoOnboarding(title: "How have you been feeling lately?", description: "You'll see quotes that fit your current mood", parameter: "feeling", options: ["Awesome", "Good", "Neutral", "Bad", "Terrible", "Other"]), InfoOnboarding(title: "What's making you feel that you?", description: "You can select more than one option", parameter: "feelingWhy", options: ["Family", "Friends", "Work", "Health", "Love", "Other"]), InfoOnboarding(title: "What areas of your life would you like to improve?", description: "Choose at least one to tailor your quotes so they resonate with you", parameter: "areasToImprove", options: ["Relationship", "Stress & anxiety", "Positive thinking", "Self-esteem", "Achieving goals", "Faith & spirituality"]),InfoOnboarding(title: "What do you want to achieve with Motivation?", description: "Choose at least one to see quotes based on your goals", parameter: "goals", options: ["Improve my self-confidence", "Accomplish my goals", "More money and success", "Find happiness", "Develop a positive mindset", "Be more present and enjoy life"])
    ]
    
    @State private var currentStep: Int = 0
    @State private var data: [String: Any] = [:]
    
    struct InfoOnboarding: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let parameter: String
        let options: [String]
    }
    
    struct OnboardingSurveyView: View {
        let info: InfoOnboarding
        
        @State private var selectedOption: String = ""
        
        @Binding var currentStep: Int
        let count: Int
        
        private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        
        @State private var name: String = ""
        @FocusState private var isFocused: Bool
        
        @Binding var data: [String: Any]
        
        var body: some View {
            VStack(spacing: 15) {
                Text(info.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 50)
                
                Text(info.description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .onAppear {
                        impactFeedback.prepare()
                    }
                
                if info.options.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enter Your Name")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.8))
                            .padding(.top, 60)
                        
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(isFocused ? .blue : .gray)
                                .padding(.leading, 10)
                            
                            TextField("Your name", text: $name)
                                .focused($isFocused)
                                .padding()
                                .background(Color.clear)
                                .foregroundColor(.black)
                                .disableAutocorrection(true)
                        }
                        .frame(height: 50)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isFocused ? Color.blue : Color.gray, lineWidth: 1)
                        )
                        .shadow(color: isFocused ? .blue.opacity(0.3) : .clear, radius: 5, x: 0, y: 2)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            Rectangle()
                                .frame(height: 2)
                                .foregroundStyle(.clear)
                            ForEach(info.options, id: \.self) { option in
                                Button(action: {
                                    impactFeedback.impactOccurred()
                                    withAnimation {
                                        selectedOption = option
                                    }
                                }) {
                                    HStack {
                                        Text(option)
                                            .font(.body)
                                            .foregroundColor(.black)
                                        Spacer()
                                        if selectedOption == option {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(selectedOption == option ? Color.blue.opacity(0.2) : Color.clear)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedOption == option ? Color.blue : Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Button(action: {
                    if !selectedOption.isEmpty || !name.isEmpty {
                        impactFeedback.impactOccurred()
                        if currentStep == count - 1 {
                            Task {
                                do {
                                    data["hoursFromGMT"] = TimeZone.current.secondsFromGMT() / 3600
                                    data["language"] = Locale.preferredLanguages.first ?? "en"
                                    try await UserAPI.shared.registerUser(withData: data)
                                    
                                    print("✅ User registered successfully")
                                } catch {
                                    print("❌ There was an error registering the user: \(error)")
                                }
                            }
                            AppProvider.shared.completeOnboarding()
                            AppProvider.shared.showInfoOnboarding = false
//                            Superwall.shared.register(event: "campaign_trigger")
                        } else {
                            withAnimation {
                                data[info.parameter] = selectedOption.isEmpty ? name : selectedOption
                                currentStep += 1
                                selectedOption = ""
                                name = ""
                            }
                        }
                    }
                }) {
                    HStack {
                        Text("Continue")
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                    }
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .background(!selectedOption.isEmpty || !name.isEmpty ? AppConstants.shared.secondaryColor : Color.gray.opacity(0.3))
                    .cornerRadius(18)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 18)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppConstants.shared.backgroundColor)
        }
    }
    
    var body: some View {
        VStack {
            OnboardingSurveyView(info: paramsList[currentStep], currentStep: $currentStep, count: paramsList.count, data: $data)
                .background(AppConstants.shared.backgroundColor)
        }
    }
}
