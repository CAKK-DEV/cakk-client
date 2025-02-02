//
//  UserSession.swift
//  UserSession
//
//  Created by 이승기 on 6/5/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import SwiftUI

import DomainUser
import OAuthToken

public final class UserSession: ObservableObject {
  
  // MARK: - Initializers
  
  private init() { }
  
  public func initialize() {
    if oauthToken.getAccessToken() == nil {
      UserDefaults.standard.setValue(false, forKey: isSignedInKey)
      isSignedIn = false
      cachedUserData = nil
    } else {
      isSignedIn = UserDefaults.standard.bool(forKey: isSignedInKey)
    }
  }
  
  
  // MARK: - Properties
  
  public static var shared = UserSession()
  private let oauthToken = OAuthTokenRepositoryImpl()
  
  
  // MARK: - UserDefaults Keys
  
  private let isSignedInKey = "com.cakk.user.is_signed_in"
  private let userDataKey = "com.cakk.user.user_data"
  private let loginProviderKey = "com.cakk.user.login_provider"
  
  
  // MARK: - Login State
  
  @Published public var isSignedIn: Bool = false
  public func update(signInState isSignedIn: Bool) {
    UserDefaults.standard.set(isSignedIn, forKey: isSignedInKey)
    self.isSignedIn = isSignedIn
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
  
  public func clearUserData() {
    cachedUserData = nil
    UserDefaults.standard.removeObject(forKey: userDataKey)
  }
  
  
  // MARK: - AccessToken
  
  public var accessToken: String? {
    get {
      if let accessToken = oauthToken.getAccessToken() {
        return accessToken
      } else {
        UserDefaults.standard.setValue(false, forKey: isSignedInKey)
        return nil
      }
    }
  }
  
  public func update(accessToken: String) {
    oauthToken.saveAccessToken(accessToken)
  }
  
  private func clearAccessToken() {
    oauthToken.deleteAccessToken()
  }
  
  
  // MARK: - RefreshToken
  
  public var refreshToken: String? {
    get {
      if let refreshToken = oauthToken.getRefreshToken() {
        return refreshToken
      } else {
        UserDefaults.standard.setValue(false, forKey: isSignedInKey)
        return nil
      }
    }
  }
  
  public func update(refreshToken: String) {
    oauthToken.saveAccessToken(refreshToken)
  }
  
  public func clearRefreshToken() {
    oauthToken.deleteRefreshToken()
  }
  
  
  // MARK: - Login Provider
  
  public var loginProvider: LoginProvider? {
    get {
      if let rawValue = UserDefaults.standard.value(forKey: loginProviderKey) as? Int {
        return LoginProvider(rawValue: rawValue)
      } else {
        return nil
      }
    }
  }
  
  public func update(loginProvider: LoginProvider) {
    UserDefaults.standard.set(loginProvider.rawValue, forKey: loginProviderKey)
  }
  
  public func clearLoginProvider() {
    UserDefaults.standard.removeObject(forKey: loginProviderKey)
  }
  
  
  // MARK: - SignOut
  
  public func clearSession() {
    clearUserData()
    clearLoginProvider()
    clearAccessToken()
    clearRefreshToken()
    
    isSignedIn = false
  }
}
