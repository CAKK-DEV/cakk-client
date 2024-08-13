//
//  EmailVerificationRepository.swift
//  DomainUser
//
//  Created by 이승기 on 8/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol EmailVerificationRepository {
  func sendVerificationCode(email: String) -> AnyPublisher<Void, EmailVerificationError>
  func confirmVerificationCode(email: String, code: String) -> AnyPublisher<Void, EmailVerificationError>
}
