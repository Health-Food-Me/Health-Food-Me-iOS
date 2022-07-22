//
//  UserManager.swift
//  HealthFoodMe
//
//  Created by Junho Lee on 2022/07/18.
//

import UIKit

final class UserManager {
    
    // MARK: - Properties
    
    static let shared = UserManager()
    private(set) var currentUser: User?
    private(set) var currentLoginStatus: Bool?
    
    @UserDefaultWrapper<String>(key: "socialToken") private(set) var socialToken
    @UserDefaultWrapper<String>(key: "accessToken") private(set) var accessToken
    @UserDefaultWrapper<String>(key: "refreshToken") private(set) var refreshToken
    @UserDefaultWrapper<String>(key: "userIdentifier") private(set) var userIdentifier
    @UserDefaultWrapper<Bool>(key: "socialType") private(set) var isAppleLogin
    @UserDefaultWrapper<String>(key: "userId") private(set) var userId
    
    var hasAccessToken: Bool { return self.accessToken != nil }
    var hasRefreshToken: Bool { return self.refreshToken != nil }
    var isAppleLoginned: Bool {
        return isAppleLogin!
    }
    var isLogin: Bool { return self.currentLoginStatus ?? false }
    var getSocialToken: String { return self.socialToken ?? "" }
    var getAccessToken: String { return self.accessToken ?? "" }
    var getRefreshToken: String { return self.refreshToken ?? "" }
    var getUser: String? { return self.userId }
    
    // MARK: - Life Cycles
    
    private init() {}
}

// MARK: - Methods

extension UserManager {
    func updateAuthToken(_ accessToken: String, _ refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func setCurrentUserWithId(_ currentUser: User) {
        self.currentUser = currentUser
        self.userId = currentUser.id
    }
    
    func setLoginStatus(isLoginned: Bool) {
        self.currentLoginStatus = isLoginned
    }
    
    func setSocialType(isAppleLogin: Bool) {
        self.isAppleLogin = isAppleLogin
    }
    
    func setUserId(userId: String) {
        self.userIdentifier = userId
    }
    
    func setSocialToken(token: String) {
        self.socialToken = token
    }
    
    func clearUserInform() {
        self.accessToken = nil
        self.refreshToken = nil
        self.currentUser = nil
        self.currentLoginStatus = nil
        self.userIdentifier = nil
        self.socialToken = nil
        self.isAppleLogin = nil
        self.userId = nil
    }
    
    func reissuanceAccessToken(completion: @escaping(Bool) -> Void) {
        AuthService.shared.reissuanceAccessToken { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? ReissunaceEntity?,
                   let access = data?.accessToken,
                   let refresh = data?.refreshToken {
                    self.updateAuthToken(access, refresh)
                }
                completion(true)
            default:
                completion(false)
                print("토큰 재발급 에러")
            }
        }
    }
}
