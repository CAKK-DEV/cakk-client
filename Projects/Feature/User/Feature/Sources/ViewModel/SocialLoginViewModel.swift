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

import Logger

import DIContainer
import AnalyticsService

public final class SocialLoginViewModel: NSObject, ObservableObject {
  
  // MARK: - Properties
  
  @Published var userData = UserData(nickname: "", email: "", birthday: .now, gender: .unknown)
  @Published private(set) var loginType: LoginProvider?
  private var credentialData: CredentialData?
  
  private let signInUseCase: SocialLoginSignInUseCase
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
  
  private let analytics: AnalyticsService?
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(signInUseCase: SocialLoginSignInUseCase) {
    self.signInUseCase = signInUseCase
    
    let diContainer = DIContainer.shared.container
    self.analytics = diContainer.resolve(AnalyticsService.self)
  }
  
  
  // MARK: - Private Methods
  
  /// DiContainer에 사용자 데이터와 자격 증명 데이터를 등록하는 함수입니다.
  ///
  /// 이 함수는 로그인 뷰모델에서 회원가입 뷰모델로 데이터를 전달하기 위해
  /// `UserData`와 `CredentialData`를 DiContainer에 등록합니다.
  /// 이를 통해 다른 뷰모델에서 DI(Dependency Injection) 컨테이너를 통해
  /// 사용자 데이터를 접근할 수 있게 됩니다.
  ///
  private func registerUserCredentialsInDiContainer() {
    let userData = userData
    DIContainer.shared.container.register(UserData.self) { _ in
      return userData
    }
    
    guard let credentialData else { return }
    DIContainer.shared.container.register(CredentialData.self) { _ in
      return credentialData
    }
  }
}


// MARK: - Google SignIn

extension SocialLoginViewModel {
  public func signInWithGoogle() {
    Loggers.featureUser.info("구글 로그인에 시도합니다.", category: .network)
    guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
    
    signInState = .loading
    
    GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] signInResult, error in
      guard let self else { return }
      
      if let error {
        Loggers.featureUser.error("에러 발생: \(error.localizedDescription)", category: .network)
        self.signInState = .failure
        return
      }
      
      guard let result = signInResult else {
        Loggers.featureUser.error("GISignInResult가 누락되었습니다.", category: .network)
        self.signInState = .failure
        return
      }
      
      guard let idToken = result.user.idToken?.tokenString else {
        Loggers.featureUser.error("구글 토큰 정보가 없습니다.", category: .network)
        self.signInState = .failure
        return
      }
      
      self.signInUseCase.execute(credential: CredentialData(loginProvider: .google, idToken: idToken))
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
          guard let self else { return }
          
          if case .failure(let error) = completion {
            switch error {
            case .failure:
              self.signInState = .failure
              
            case .newUser:
              Loggers.featureUser.info("등록된 계정이 없어 계정을 신규등록합니다.", category: .network)
              guard let profile = result.user.profile else {
                Loggers.featureUser.error("계정 등록에 필요한 계정 정보가 누락되었습니다.", category: .network)
                self.signInState = .failure
                return
              }
              self.credentialData = .init(loginProvider: .google, idToken: idToken)
              self.loginType = .google
              self.userData.nickname = profile.name
              self.userData.email = profile.email
              
              self.registerUserCredentialsInDiContainer()
              self.signInState = .newUser
              
            case .serverError:
              self.signInState = .serverError
            }
          }
        }, receiveValue: { [weak self] _ in
          self?.signInState = .loggedIn
          self?.analytics?.logSignIn(method: .google)
        })
        .store(in: &cancellables)
    }
  }
}


// MARK: - KaKao SignIn

extension SocialLoginViewModel {
  public func signInWithKakao() {
    Loggers.featureUser.info("카카오 로그인에 시도합니다.", category: .network)
    signInState = .loading
    
    if UserApi.isKakaoTalkLoginAvailable() {
      /// 카카오가 설치되어있는 경우
      UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
        guard let self = self else { return }
        
        if let error = error {
          Loggers.featureUser.error("에러 발생\(error.localizedDescription)", category: .network)
          self.signInState = .failure
          return
        }
        
        guard let idToken = oauthToken?.idToken else {
          Loggers.featureUser.error("OAuth token 정보를 받아오는데 실패하였습니다.", category: .network)
          self.signInState = .failure
          return
        }
        
        self.signInUseCase.execute(credential: CredentialData(loginProvider: .kakao, idToken: idToken))
          .subscribe(on: DispatchQueue.global())
          .receive(on: DispatchQueue.main)
          .sink { [weak self] completion in
            if case .failure(let error) = completion {
              switch error {
              case .failure:
                self?.signInState = .failure
                
              case .newUser:
                UserApi.shared.me { [weak self] user, error in
                  guard let self = self else { return }
                  
                  if let error = error {
                    Loggers.featureUser.error("에러 발생\(error.localizedDescription)", category: .network)
                    self.signInState = .failure
                    return
                  }
                  
                  guard let name = user?.properties?["nickname"] else {
                    Loggers.featureUser.error("유저 정보를 받아오는데 실패하였습니다.", category: .network)
                    self.signInState = .failure
                    return
                  }
                  
                  self.credentialData = .init(loginProvider: .kakao, idToken: idToken)
                  self.loginType = .kakao
                  self.userData.nickname = name
                  
                  self.registerUserCredentialsInDiContainer()
                  self.signInState = .newUser
                }
                
              case .serverError:
                self?.signInState = .serverError
              }
            }
          } receiveValue: { [weak self] in
            self?.signInState = .loggedIn
            self?.analytics?.logSignIn(method: .kakao)
          }
          .store(in: &cancellables)
      }
    } else {
      /// 카카오가 설치되어있지 않은 경우
      UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
        guard let self else { return }
        
        if let error = error {
          Loggers.featureUser.error("에러 발생\(error.localizedDescription)", category: .network)
          self.signInState = .failure
          return
        }
        
        guard let idToken = oauthToken?.idToken else {
          Loggers.featureUser.error("OAuth token 정보를 받아오는데 실패하였습니다.", category: .network)
          self.signInState = .failure
          return
        }
        
        self.signInUseCase.execute(credential: CredentialData(loginProvider: .kakao, idToken: idToken))
          .subscribe(on: DispatchQueue.global())
          .receive(on: DispatchQueue.main)
          .sink { [weak self] completion in
            if case .failure(let error) = completion {
              switch error {
              case .failure:
                self?.signInState = .failure
                
              case .newUser:
                UserApi.shared.me { [weak self] user, error in
                  guard let self = self else { return }
                  
                  if let error = error {
                    Loggers.featureUser.error("에러 발생\(error.localizedDescription)", category: .network)
                    self.signInState = .failure
                    return
                  }
                  
                  guard let name = user?.properties?["nickname"] else {
                    Loggers.featureUser.error("유저 정보를 받아오는데 실패하였습니다.", category: .network)
                    self.signInState = .failure
                    return
                  }
                  
                  self.credentialData = .init(loginProvider: .kakao, idToken: idToken)
                  self.loginType = .kakao
                  self.userData.nickname = name
                  
                  self.registerUserCredentialsInDiContainer()
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
    }
  }
}


// MARK: - Apple SignIn

extension SocialLoginViewModel: ASAuthorizationControllerDelegate {
  public func signInWithApple() {
    Loggers.featureUser.info("애플 로그인에 시도합니다.", category: .network)
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
      Loggers.featureUser.error("id token을 받아오는데 실패하였습니다.", category: .network)
      signInState = .failure
      return
    }

    signInUseCase.execute(credential: CredentialData(loginProvider: .apple, idToken: idToken))
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] result in
        guard let self else { return }
        
        if case .failure(let error) = result {
          switch error {
          case .failure:
            self.signInState = .failure
            
          case .newUser:
            if let email = credential.email,
              let fullName = credential.fullName {
              self.credentialData = .init(loginProvider: .apple, idToken: idToken)
              self.userData.email = email
              self.userData.nickname = "\(fullName.familyName ?? "")\(fullName.givenName ?? "")"
              
              self.registerUserCredentialsInDiContainer()
              self.signInState = .newUser
            } else {
              self.signInState = .appleSingInExpired
            }
            
          case .serverError:
            self.signInState = .serverError
          }
        }
      } receiveValue: { [weak self] _ in
        self?.signInState = .loggedIn
        self?.analytics?.logSignIn(method: .apple)
      }
      .store(in: &cancellables)
  }
  
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
    print(error.localizedDescription)
    signInState = .failure
  }
}
