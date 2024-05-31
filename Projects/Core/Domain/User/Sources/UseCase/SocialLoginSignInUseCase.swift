//
//  SocialLoginSignInUseCase.swift
//  CAKK
//
//  Created by 이승기 on 5/15/24.
//

import Foundation
import Combine

public protocol SocialLoginSignInUseCase {
  func execute(credential: CredentialData) -> AnyPublisher<Void, SocialLoginSignInError>
}
