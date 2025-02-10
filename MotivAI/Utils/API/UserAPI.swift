//
//  UserAPI.swift
//  MotivAI
//
//  Created by Petru Grigor on 27.01.2025.
//

import Foundation

class UserAPI {
    static let shared = UserAPI()
    
    private init() {}
    
    var fcmTokenId: String = ""
    
    struct UserResponse: Codable {
        let id: String
    }
    
    func registerUser(withData data: [String: Any]) async throws {
        guard let url = URL(string: "http://localhost:5287/api/user/register-user?applicationCode=\(AppConstants.shared.appCode)") else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["appVersion": AppConstants.shared.appVersion, "fireBaseId": fcmTokenId, "customData": data]
        
        let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        
        print(String(data: jsonData, encoding: .utf8) ?? "No JSON data")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
        AppConstants.shared.saveUserId(userResponse.id)
    }
}
