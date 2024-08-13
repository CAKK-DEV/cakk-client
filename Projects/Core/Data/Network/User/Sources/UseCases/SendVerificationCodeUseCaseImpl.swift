//
//  SendVerificationCodeUseCaseImpl.swift
//  NetworkUser
//
//  Created by 이승기 on 8/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

public final class SendVerificationCodeUseCaseImpl: SendVerificationCodeUseCase {
  
  // MARK: - Properties
  
  private let repository: EmailVerificationRepository
  
  
  // MARK: - Initializers
  
  public init(repository: EmailVerificationRepository) {
    self.repository = repository
  }
  
  
  // MARK: - Public Methods
  
  public func sendVerificationCode(email: String) -> AnyPublisher<Void, EmailVerificationError> {
    repository.sendVerificationCode(email: email)
  }
}
