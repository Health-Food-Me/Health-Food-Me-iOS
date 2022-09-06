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
    
    // 카카오 / 애플 토큰
    @UserDefaultWrapper<String>(key: "socialToken") private(set) var socialToken
    
    // 헬푸미 토큰
    @UserDefaultWrapper<String>(key: "accessToken") private(set) var accessToken
    @UserDefaultWrapper<String>(key: "refreshToken") private(set) var refreshToken
    
    // 헬푸미 userId
    @UserDefaultWrapper<String>(key: "userId") private(set) var userId
    
    // 둘러보기 플로우 판단
    @UserDefaultWrapper<Bool>(key: "isBrowsing") private(set) var isBrowsingFlow
    
    // 애플로그인을 위한 userID
    @UserDefaultWrapper<String>(key: "userIdentifier") private(set) var userIdentifier
    
    // socialType
    @UserDefaultWrapper<Bool>(key: "socialType") private(set) var isAppleLogin
    
    var hasAccessToken: Bool { return self.accessToken != nil }
    var hasRefreshToken: Bool { return self.refreshToken != nil }
    var isAppleLoginned: Bool {
        return isAppleLogin!
    }
    var isLogin: Bool { return self.currentLoginStatus ?? false }
    var isBrowsing: Bool { return self.isBrowsingFlow ?? false }
    
    var getSocialToken: String { return self.socialToken ?? "" }
    var getAccessToken: String { return self.accessToken ?? "" }
    var getRefreshToken: String { return self.refreshToken ?? "" }
    var getUser: String? { return self.userId }
    
    // MARK: - Life Cycles
    
    private init() {}
}

// MARK: - Methods

extension UserManager {
    /// 헬푸미 토큰을 업데이트합니다.
    func updateHelfmeToken(_ accessToken: String, _ refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    /// 둘러보기 플로우의 여부를 저장합니다.
    func updateBorwsingstate(isBrwosingFlow: Bool) {
        self.isBrowsingFlow = isBrwosingFlow
    }
    
    /// 헬푸미 유저 객체를 헬푸미 userId와 함께 저장합니다.
    func setCurrentUserWithId(_ currentUser: User) {
        self.currentUser = currentUser
        self.userId = currentUser.id
    }
    
    /// 현재 로그인상태인지에 대해 Bool타입으로 저장합니다.
    func setLoginStatus(isLoginned: Bool) {
        self.currentLoginStatus = isLoginned
    }
    
    /// apple / kakao 등의 소셜 타입 종류를 지정합니다.
    func setSocialType(isAppleLogin: Bool) {
        self.isAppleLogin = isAppleLogin
    }
    
    /// appleLogin의 경우 userID를 저장해 놓습니다.
    func setUserIdForApple(userId: String) {
        self.userIdentifier = userId
    }
    
    /// socialToken을 저장해놓고 사용합니다.
    func setSocialToken(token: String) {
        self.socialToken = token
    }
    
    /// 유저에 대한 정보를 초기화합니다.
    func clearUserInform() {
        self.accessToken = nil
        self.refreshToken = nil
        self.currentUser = nil
        self.currentLoginStatus = nil
        self.userIdentifier = nil
        self.socialToken = nil
        self.isAppleLogin = nil
        self.userId = nil
        self.isBrowsingFlow = nil
    }
    
    /// 가지고 있는 refreshtoken을 가지고 새로운 accesstoken과 refreshtoken을 발급받습니다.
    func reissuanceAccessToken(completion: @escaping(Bool) -> Void) {
        AuthService.shared.reissuanceAccessToken { networkResult in
            switch networkResult {
            case .success(let data):
                if let data = data as? ReissunaceEntity?,
                   let access = data?.accessToken,
                   let refresh = data?.refreshToken {
                    self.updateHelfmeToken(access, refresh)
                }
                completion(true)
            default:
                completion(false)
                print("토큰 재발급 에러")
            }
        }
    }
}
