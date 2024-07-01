//
//  AdminLoginViewModel.swift
//  FeatureUserAdmin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Combine

import DomainUser
import GoogleSignIn

import Moya

public final class AdminLoginViewModel: NSObject, ObservableObject {
  
  // MARK: - Properties
  
  @Published var userData = UserData(nickname: "", email: "", birthday: .now, gender: .unknown)
  
  @Published private(set) var signingState: SignInState = .idle
  enum SignInState: Equatable {
    case idle
    case loading
    case failure
    case appleSingInExpired
    case serverError
    case loggedIn
  }
  
  private let signInUseCase: SocialLoginSignInUseCase
  private let signUpUseCase: SocialLoginSignUpUseCase
  
  private var credentialData: CredentialData?
  private var cancellables = Set<AnyCancellable>()

  
  
  // MARK: - Initializers
  
  public init(
    signInUseCase: SocialLoginSignInUseCase,
    signUpUseCase: SocialLoginSignUpUseCase
  ) {
    self.signInUseCase = signInUseCase
    self.signUpUseCase = signUpUseCase
  }
}


// MARK: - SignUP

extension AdminLoginViewModel {
  public func signUp() {
    signingState = .loading
    
    // 모든 항목 존재하는지 검사.
    guard let credentialData else {
      signingState = .failure
      return
    }
    if userData.nickname.isEmpty && userData.email.isEmpty {
      signingState = .failure
      return
    }
    
    signUpUseCase.execute(credential: credentialData, userData: userData)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          switch error {
          case .failure, .userAlreadyExists:
            self?.signingState = .failure
          case .serverError:
            self?.signingState = .serverError
          }
        }
      } receiveValue: { [weak self] _ in
        self?.signingState = .loggedIn
      }
      .store(in: &cancellables)
  }
}


// MARK: - Google SignIn

extension AdminLoginViewModel {
  public func signInWithGoogle() {
    guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
    
    signingState = .loading
    
    GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] signInResult, error in
      guard let self else { return }
      
      if let error {
        print(error.localizedDescription)
        self.signingState = .failure
        return
      }
      
      guard let result = signInResult else {
        self.signingState = .failure
        return
      }
      
      guard let idToken = result.user.idToken?.tokenString else {
        self.signingState = .failure
        return
      }
      
      self.signInUseCase.execute(credential: CredentialData(loginProvider: .google, idToken: idToken))
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
          if case .failure(let error) = completion {
            switch error {
            case .failure:
              self?.signingState = .failure
              
            case .newUser:
              guard let profile = result.user.profile else {
                self?.signingState = .failure
                return
              }
              self?.credentialData = .init(loginProvider: .google, idToken: idToken)
              self?.userData.nickname = profile.name
              self?.userData.email = profile.email
              self?.signUp()
              
            case .serverError:
              self?.signingState = .serverError
            }
          }
        }, receiveValue: { [weak self] _ in
          self?.signingState = .loggedIn
        })
        .store(in: &cancellables)
    }
  }
}
