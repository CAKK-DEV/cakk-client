//
//  SocialLoginViewModel.swift
//  CAKK
//
//  Created by 이승기 on 5/13/24.
//

import SwiftUI
import Combine

import DomainUser

import AuthenticationServices
import KakaoSDKUser
import GoogleSignIn

import Moya

public final class SocialLoginViewModel: NSObject, ObservableObject {
  
  // MARK: - Properties
  
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
    case noKakaoAvailable
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
  
  private var credentialData: CredentialData?
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
    
    // 모든 항목 존재하는지 검사.
    guard let credentialData else {
      signUpState = .failure
      return
    }
    if userData.nickname.isEmpty && userData.email.isEmpty {
      signUpState = .failure
      return
    }
    
    signUpUseCase.execute(credential: credentialData, userData: userData)
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
        print(error.localizedDescription)
        self.signInState = .failure
        return
      }
      
      guard let result = signInResult else {
        self.signInState = .failure
        return
      }
      
      guard let idToken = result.user.idToken?.tokenString else {
        self.signInState = .failure
        return
      }
      
      self.signInUseCase.execute(credential: CredentialData(loginProvider: .google, idToken: idToken))
        .sink(receiveCompletion: { [weak self] completion in
          if case .failure(let error) = completion {
            switch error {
            case .failure:
              self?.signInState = .failure
              
            case .newUser:
              guard let profile = result.user.profile else {
                self?.signInState = .failure
                return
              }
              self?.credentialData = .init(loginProvider: .google, idToken: idToken)
              self?.loginType = .google
              self?.userData.nickname = profile.name
              self?.userData.email = profile.email
              self?.signInState = .newUser
              
            case .serverError:
              self?.signInState = .serverError
            }
          }
        }, receiveValue: { [weak self] _ in
          self?.signInState = .loggedIn
        })
        .store(in: &cancellables)
    }
  }
}


// MARK: - KaKao SignIn

extension SocialLoginViewModel {
  public func signInWithKakao() {
    signInState = .loading
    
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
        guard let self = self else { return }
        
        if let error = error {
          print(error.localizedDescription)
          self.signInState = .failure
          return
        }
        
        guard let idToken = oauthToken?.idToken else {
          print("Failed to get oauth token")
          self.signInState = .failure
          return
        }
        
        self.signInUseCase.execute(credential: CredentialData(loginProvider: .kakao, idToken: idToken))
          .sink { [weak self] completion in
            if case .failure(let error) = completion {
              switch error {
              case .failure:
                self?.signInState = .failure
                
              case .newUser:
                UserApi.shared.me { [weak self] user, error in
                  guard let self = self else { return }
                  
                  if let error = error {
                    print(error)
                    self.signInState = .failure
                    return
                  }
                  
                  guard let name = user?.properties?["nickname"] else {
                    print("Failed to get user info")
                    self.signInState = .failure
                    return
                  }
                  
                  self.credentialData = .init(loginProvider: .kakao, idToken: idToken)
                  self.loginType = .kakao
                  self.userData.nickname = name
                  self.signInState = .newUser
                }
                
              case .serverError:
                self?.signInState = .serverError
              }
            }
          } receiveValue: { [weak self] in
            self?.signInState = .loggedIn
          }
          .store(in: &cancellables)
      }
    } else {
      signInState = .noKakaoAvailable
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
      signInState = .failure
      return
    }

    signInUseCase.execute(credential: CredentialData(loginProvider: .apple, idToken: idToken))
      .sink { [weak self] result in
        if case .failure(let error) = result {
          switch error {
          case .failure:
            self?.signInState = .failure
            
          case .newUser:
            if let email = credential.email,
              let fullName = credential.fullName {
              self?.credentialData = .init(loginProvider: .apple, idToken: idToken)
              self?.userData.email = email
              self?.userData.nickname = "\(fullName.familyName ?? "")\(fullName.givenName ?? "")"
              self?.signInState = .newUser
            } else {
              self?.signInState = .appleSingInExpired
            }
            
          case .serverError:
            self?.signInState = .serverError
          }
        }
      } receiveValue: { [weak self] _ in
        self?.signInState = .loggedIn
      }
      .store(in: &cancellables)
  }
  
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
    print(error)
    signInState = .failure
  }
}
