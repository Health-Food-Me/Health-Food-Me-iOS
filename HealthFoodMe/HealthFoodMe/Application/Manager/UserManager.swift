//
//  UserManager.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/18.
//

import RxSwift
import UIKit

final class UserManager {
    
    // MARK: - Properties
    
    static let shared = UserManager()
    private(set) var currentUser: User?
    
    @UserDefaultWrapper<String>(key: "accessToken") private(set) var accessToken
    @UserDefaultWrapper<String>(key: "refreshToken") private(set) var refreshToken
    
    var hasAccessToken: Bool { return self.accessToken != nil }
    var hasRefreshToken: Bool { return self.refreshToken != nil }
    
    private init() {
        
    }
    
    func updateAuthToken(_ accessToken: String, _ refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func setCurrentUser(_ currentUser: User) {
        self.currentUser = currentUser
    }
    
    func clearUserInform() {
        self.accessToken = nil
        self.refreshToken = nil
        self.currentUser = nil
    }
    
    func reissuanceAccessToken() {
        guard let accessToken = self.accessToken   else { return }
        guard let refreshToken = self.refreshToken else { return }
        
        AuthService.shared.reissuanceAccessToken()
    }
}

struct User {
    
}
