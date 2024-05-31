//
//  SocialLoginSignUpUseCase.swift
//  CAKK
//
//  Created by 이승기 on 5/11/24.
//

import Foundation
import Combine

public protocol SocialLoginSignUpUseCase {
  func execute(credential: CredentialData, userData: UserData) -> AnyPublisher<Void, SocialLoginSignUpError>
}
