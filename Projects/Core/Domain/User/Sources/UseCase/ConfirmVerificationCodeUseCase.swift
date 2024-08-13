//
//  ConfirmVerificationCodeUseCase.swift
//  DomainUser
//
//  Created by 이승기 on 8/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol ConfirmVerificationCodeUseCase {
  func confirmVerificationCode(email: String, code: String) -> AnyPublisher<Void, EmailVerificationError>
}
