//
//  SocialLoginViewModel.swift
//  CAKK
//
//  Created by 이승기 on 5/13/24.
//

import SwiftUI
import Combine
import Moya

import DomainUser

import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn

public final class SocialLoginViewModel: NSObject, ObservableObject {
  
  // MARK: - Properties
  
  private var credentialData: CredentialData?
  @Published var userData = UserData(nickname: "", email: "", birthday: .now, gender: .unknown)
  @Published private(set) var loginType: LoginProvider?
  
  @Published private(set) var signInState: SignInState = .idle
  enum SignInState: Equatable {
    case idle
    case loading
    case failure
    case appleSingInExpired
    case serverError
    case loggedIn
    case newUser
  }
  
  @Published private(set) var signUpState: SignUpState = .idle
  enum SignUpState: Equatable {
    case idle
    case loading
    case failure
    case serverError
    case success
  }
  
  private let signInUseCase: SocialLoginSignInUseCase
  private let signUpUseCase: SocialLoginSignUpUseCase
  
  private var cancellables = Set<AnyCancellable>()
  
  var isEmailValid: Bool {
    let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: userData.email.utf16.count)
    return regex?.firstMatch(in: userData.email, options: [], range: range) != nil
  }
  
  var isEmailEmpty: Bool {
    userData.email.isEmpty
  }
  
  // MARK: - Initializers
  
  public init(
    signInUseCase: SocialLoginSignInUseCase,
    signUpUseCase: SocialLoginSignUpUseCase)
  {
    self.signInUseCase = signInUseCase
    self.signUpUseCase = signUpUseCase
  }
}


// MARK: - SignUP

extension SocialLoginViewModel {
  public func signUp() {
    signUpState = .loading
    
    // (1) 모든 항목 존재하는지 검사.
    if userData.nickname.isEmpty || userData.email.isEmpty {
      signUpState = .failure
      return
    }
    
    guard let credentialData = credentialData else {
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
        self?.signUpState = .success
      }
      .store(in: &cancellables)
  }
}


// MARK: - Google SignIn

extension SocialLoginViewModel {
  public func signInWithGoogle() {
    guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
    
    signInState = .loading
    
    GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] signInResult, error in
      guard let self else { return }
      
      if let error {
        self.handleSignInError(error)
        return
      }
      
      guard let result = signInResult, let idToken = result.user.idToken?.tokenString else {
        self.signInState = .failure
        return
      }
      
      let credentialData = CredentialData(loginProvider: .google, idToken: idToken)
      let signUpProcess = {
        self.loginType = .google
        
        guard let profile = result.user.profile else {
          self.signInState = .failure
          return
        }
        self.userData.nickname = profile.name
        self.userData.email = profile.email
        self.signInState = .newUser
      }
      self.signIn(credentialData: credentialData, signUpProcess: signUpProcess)
    }
  }
}


// MARK: - KaKao SignIn

extension SocialLoginViewModel {
  public func signInWithKakao() {
    signInState = .loading
    
    let signInCompletion: (OAuthToken?, Error?) -> Void = { [weak self] oauthToken, error in
      guard let self = self else { return }
      
      if let error = error {
        self.handleSignInError(error)
        return
      }
      
      guard let idToken = oauthToken?.idToken else {
        self.signInState = .failure
        return
      }
      
      let credentialData = CredentialData(loginProvider: .kakao, idToken: idToken)
      let signUpProcess = {
        self.loginType = .kakao
        
        UserApi.shared.me { [weak self] user, error in
          guard let self = self else { return }
          
          if let error = error {
            self.handleSignInError(error)
            return
          }
          
          guard let name = user?.properties?["nickname"] else {
            self.signInState = .failure
            return
          }
          
          self.userData.nickname = name
          self.signInState = .newUser
        }
      }
      self.signIn(credentialData: credentialData, signUpProcess: signUpProcess)
    }
    
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk(completion: signInCompletion)
    } else {
      UserApi.shared.loginWithKakaoAccount(completion: signInCompletion)
    }
  }
}


// MARK: - Apple SignIn

extension SocialLoginViewModel: ASAuthorizationControllerDelegate {
  public func signInWithApple() {
    signInState = .loading
    
    let appleIdProvider = ASAuthorizationAppleIDProvider()
    let request = appleIdProvider.createRequest()
    
    request.requestedScopes = [.email, .fullName]
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.performRequests()
  }
  
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
    
    guard let idToken = String(data: credential.identityToken ?? Data(), encoding: .utf8) else {
      self.signInState = .failure
      return
    }
    
    let credentialData = CredentialData(loginProvider: .apple, idToken: idToken)
    let signUpProcess = {
      self.loginType = .apple
      if let email = credential.email, let fullName = credential.fullName {
        self.userData.email = email
        self.userData.nickname = "\(fullName.familyName ?? "")\(fullName.givenName ?? "")"
        self.signInState = .newUser
      } else {
        self.signInState = .appleSingInExpired
      }
    }
    
    signIn(credentialData: credentialData, signUpProcess: signUpProcess)
  }
  
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
    handleSignInError(error)
  }
  
  
  // MARK: - Private Methods
  
  private func signIn(credentialData: CredentialData, signUpProcess: (() -> Void)? = nil) {
    // (2) 공통 signIn 처리 메서드
    self.credentialData = credentialData
    
    signInUseCase.execute(credential: credentialData)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] result in
        if case .failure(let error) = result {
          self?.handleSignInFailure(error: error, signUpProcess: signUpProcess)
        }
      } receiveValue: { [weak self] in
        self?.signInState = .loggedIn
      }
      .store(in: &cancellables)
  }
  
  private func handleSignInFailure(error: SocialLoginSignInError, signUpProcess: (() -> Void)?) {
    switch error {
    case .failure:
      signInState = .failure
      
    case .newUser:
      signUpProcess?()
      
    case .serverError:
      signInState = .serverError
    }
  }
  
  private func handleSignInError(_ error: Error) {
    print(error.localizedDescription)
    signInState = .failure
  }
}
