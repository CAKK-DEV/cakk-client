//
//  SocialLoginSignUpViewModel.swift
//  FeatureUser
//
//  Created by 이승기 on 8/24/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine
import DIContainer

import DomainUser

import AnalyticsService
import Logger

public final class SocialLoginSignUpViewModel: ObservableObject {
  
  // MARK: - Properties

  private(set) var loginType: LoginProvider
  @Published var userData: UserData
  private var credentialData: CredentialData
  
  private let signUpUseCase: SocialLoginSignUpUseCase
  @Published private(set) var signUpState: SignUpState = .idle
  enum SignUpState: Equatable {
    case idle
    case loading
    case failure
    case serverError
    case success
  }
  
  var isEmailValid: Bool {
    let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: userData.email.utf16.count)
    return regex?.firstMatch(in: userData.email, options: [], range: range) != nil
  }
  
  var isEmailEmpty: Bool {
    userData.email.isEmpty
  }
  
  private let analytics: AnalyticsService?
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    loginType: LoginProvider,
    userData: UserData,
    credentialData: CredentialData,
    signUpUseCase: SocialLoginSignUpUseCase
  ) {
    self.loginType = loginType
    self.userData = userData
    self.credentialData = credentialData
    self.signUpUseCase = signUpUseCase
    
    let diContainer = DIContainer.shared.container
    self.analytics = diContainer.resolve(AnalyticsService.self)
  }
  
  
  // MARK: - SignUP
  
  public func signUp() {
    signUpState = .loading
    
    /// 모든 항목 존재하는지 검사.
    if userData.nickname.isEmpty && userData.email.isEmpty {
      Loggers.featureUser.info("이름 또는 이메일정보가 없습니다.", category: .network)
      signUpState = .failure
      return
    }
    
    signUpUseCase.execute(credential: credentialData, userData: userData)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          switch error {
          case .failure, .userAlreadyExists:
            self?.signUpState = .failure
          case .serverError:
            self?.signUpState = .serverError
          }
        }
      } receiveValue: { [weak self] _ in
        guard let self else { return }
        
        self.signUpState = .success
        
        switch self.loginType {
        case .apple:
          analytics?.logSignUp(method: .apple)
        case .google:
          analytics?.logSignUp(method: .google)
        case .kakao:
          analytics?.logSignUp(method: .kakao)
        }
      }
      .store(in: &cancellables)
  }
}
