//
//  UserDefaultsUserSession.swift
//  UserDefaultsUserSession
//
//  Created by 이승기 on 6/5/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser
import OAuthToken

public final class UserDefaultsUserSession: UserSession {
  
  // MARK: - Initializers
  
  private init() { }
  
  
  // MARK: - Properties
  
  public static var shared = UserDefaultsUserSession()
  private let oauthToken = OAuthTokenRepositoryImpl()
  
  
  // MARK: - UserDefaults Keys
  
  private let isLoggedInKey = "com.cakk.user.is_logged_in"
  private let userDataKey = "com.cakk.user.user_data"
  
  
  // MARK: - Login State
  
  public var isSignedIn: Bool {
    get {
      UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
  }
  
  public func update(signInState isSignedIn: Bool) {
    UserDefaults.standard.set(isSignedIn, forKey: isLoggedInKey)
  }
  
  
  // MARK: - UserData
  
  private var cachedUserData: UserData?
  public var userData: UserData? {
    get {
      if let cachedUserData = cachedUserData {
        return cachedUserData
      }
      if let data = UserDefaults.standard.data(forKey: userDataKey),
         let userData = try? JSONDecoder().decode(UserData.self, from: data) {
        self.cachedUserData = userData
        return userData
      }
      return nil
    }
  }
  
  public func update(userData: UserData) {
    if let data = try? JSONEncoder().encode(userData) {
      UserDefaults.standard.set(data, forKey: userDataKey)
      cachedUserData = userData
    } else {
      UserDefaults.standard.removeObject(forKey: userDataKey)
    }
  }
  
  
  // MARK: - AccessToken
  
  public var accessToken: String? {
    get {
      oauthToken.getAccessToken()
    }
  }
  
  public func update(accessToken: String) {
    oauthToken.saveAccessToken(accessToken)
  }
  
  
  // MARK: - RefreshToken
  
  public var refreshToken: String? {
    get {
      oauthToken.getRefreshToken()
    }
  }
  
  public func update(refreshToken: String) {
    oauthToken.saveAccessToken(refreshToken)
  }
}
