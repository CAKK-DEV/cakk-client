//
//  EmailVerificationViewModel.swift
//  FeatureUser
//
//  Created by 이승기 on 8/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser
import Logger

public class EmailVerificationViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published var timeRemaining: Int = 180 /// 이메일 인증 가능 시간  60초 * 3
  private var timerSubscription: AnyCancellable?
  
  private let confirmVerificationCodeUseCase: ConfirmVerificationCodeUseCase
  private let sendVerificationCodeUseCase: SendVerificationCodeUseCase
  @Published var verificationCode = ""
  @Published private(set) var emailVerificationState: EmailVerificationState = .idle
  enum EmailVerificationState: Equatable {
    case idle
    case serverError
    
    /// 인증코드를 이메일로 보내는 상태
    case sendingRequestVerificationCode
    
    /// 인증코드 발송 실패 상태
    case requestVerificationCodeFailure
    
    /// 인증번호를 입력받기를 대기하는 상태
    case waitingForVerify
    
    /// 입력한 인증번호를 이용해서 인증하는 과정의 상태
    case requestConfirmVerificationCode
    
    /// 인증번호 인증 실패 상태
    case confirmVerificationCodeFailure
    
    /// 인증 됨
    case verified
    
    /// 인증번호가 일치하지 않는 경우
    case notMatched
    
    /// 인증 가능한 시간이 만료 되었을 때
    case timeExpired
  }
  
  var isVerificationCodeValid: Bool {
      let regex = "^[0-9]{6}$"
      return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: verificationCode)
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    sendVerificationCodeUseCase: SendVerificationCodeUseCase,
    confirmVerificationCodeUseCase: ConfirmVerificationCodeUseCase
  ) {
    self.sendVerificationCodeUseCase = sendVerificationCodeUseCase
    self.confirmVerificationCodeUseCase = confirmVerificationCodeUseCase
  }
  
  deinit {
    stopTimer()
  }
  
  
  // MARK: - Public Methods
  
  public func sendVerificationCodeThrough(email: String) {
    emailVerificationState = .sendingRequestVerificationCode
    
    sendVerificationCodeUseCase.sendVerificationCode(email: email)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion {
        case .failure(let error):
          switch error {
          case .serverError:
            self?.emailVerificationState = .serverError
          default:
            self?.emailVerificationState = .requestVerificationCodeFailure
          }
          
        case .finished:
          self?.emailVerificationState = .waitingForVerify
          self?.startTimer()
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
  }
  
  public func confirmVerificationCode(email: String) {
    emailVerificationState = .requestConfirmVerificationCode
    
    confirmVerificationCodeUseCase.confirmVerificationCode(email: email, code: verificationCode)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion {
        case .failure(let error):
          switch error {
          case .serverError:
            self?.emailVerificationState = .serverError
          case .failure:
            self?.emailVerificationState = .confirmVerificationCodeFailure
          case .wrongVerificationCode:
            self?.emailVerificationState = .notMatched
          }
          
        case .finished:
          self?.emailVerificationState = .verified
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
  }
  
  public func startTimer() {
    stopTimer() // 타이머를 다시 시작할 때 중복 방지를 위해 기존 타이머를 중지
    timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        guard let self = self else { return }
        if self.timeRemaining > 0 {
          self.timeRemaining -= 1
        } else {
          self.stopTimer()
          self.emailVerificationState = .timeExpired
        }
      }
  }
  
  public func stopTimer() {
    timerSubscription?.cancel()
  }
}
