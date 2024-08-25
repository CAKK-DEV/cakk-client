//
//  SocialLoginRepository.swift
//  DomainUser
//
//  Created by 이승기 on 5/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol SocialLoginRepository {
  func signIn(credential: CredentialData) -> AnyPublisher<SocialLoginResponse, SocialLoginSignInError>
  func signUp(auth: AuthData) -> AnyPublisher<SocialLoginResponse, SocialLoginSignUpError>
  func signOut(accessToken: String, refreshToken: String) -> AnyPublisher<Void, Error>
}
