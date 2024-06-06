//
//  MockUserSession.swift
//  PreviewSupportUser
//
//  Created by 이승기 on 6/6/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainUser

public final class MockUserSession: UserSession {
  public static var shared = MockUserSession()
  
  private init() {
    self.isSignedIn = true
  }
  
  public var isSignedIn: Bool
  public func update(signInState isSignedIn: Bool) {
    self.isSignedIn = true
  }
  
  public var userData: DomainUser.UserData?
  public func update(userData: DomainUser.UserData) { }
  
  public var accessToken: String?
  public func update(accessToken: String) { }
  
  public var refreshToken: String?
  public func update(refreshToken: String) { }
}
