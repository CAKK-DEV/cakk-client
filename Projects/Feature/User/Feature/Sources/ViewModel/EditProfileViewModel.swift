//
//  EditProfileViewModel.swift
//  FeatureUser
//
//  Created by 이승기 on 6/14/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

import UserSession

public final class EditProfileViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private let userProfileUseCase: UserProfileUseCase
  private(set) var originalUserProfile: UserProfile!
  @Published private(set) var userProfileFetchingState: UserProfileFetchingState = .idle
  enum UserProfileFetchingState: Equatable {
    case idle
    case loading
    case success
    case failure(error: UserProfileError)
  }
  
  private let updateUserProfileUseCase: UpdateUserProfileUseCase
  @Published var editedUserProfile: NewUserProfile!
  @Published private(set) var userProfileUpdatingState: UserProfileUpdatingState = .idle
  enum UserProfileUpdatingState: Equatable {
    case idle
    case loading
    case success
    case failure(error: UserProfileError)
  }
  
  private let signOutUseCase: SocialLoginSignOutUseCase
  @Published private(set) var signOutState: SignOutState = .idle
  enum SignOutState {
    case idle
    case loading
    case success
    case failure
  }
  
  private let withdrawUseCase: WithdrawUseCase
  @Published private(set) var withdrawState: WithdrawState = .idle
  enum WithdrawState: Equatable {
    case idle
    case loading
    case success
    case failure(error: UserProfileError)
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    userProfileUseCase: UserProfileUseCase,
    updateUserProfileUseCase: UpdateUserProfileUseCase,
    signOutUseCase: SocialLoginSignOutUseCase,
    withdrawUseCase: WithdrawUseCase
  ) {
    self.userProfileUseCase = userProfileUseCase
    self.updateUserProfileUseCase = updateUserProfileUseCase
    self.signOutUseCase = signOutUseCase
    self.withdrawUseCase = withdrawUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchUserProfile() {
    userProfileFetchingState = .loading
    
    userProfileUseCase.execute()
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.userProfileFetchingState = .failure(error: error)
          UserSession.shared.clearSession()
        } else {
          self?.userProfileFetchingState = .success
        }
      } receiveValue: { [weak self] userProfile in
        self?.originalUserProfile = userProfile
        self?.editedUserProfile = .init(
          profileImage: userProfile.profileImageUrl == nil ? .none : .original(imageUrl: userProfile.profileImageUrl!),
          nickname: userProfile.nickname,
          email: userProfile.email,
          gender: userProfile.gender,
          birthday: userProfile.birthday)
      }
      .store(in: &cancellables)
  }
  
  public func profileHasChanges() -> Bool {
    if editedUserProfile.profileImage != .none
        && editedUserProfile.profileImage != .original(imageUrl: originalUserProfile.profileImageUrl ?? "") {
      /// 프로필 이미지를 삭제하려거나 새로운 이미지를 등록하려는 경우
      return true
    } else if originalUserProfile.nickname != editedUserProfile.nickname ||
                originalUserProfile.gender != editedUserProfile.gender ||
                originalUserProfile.birthday != editedUserProfile.birthday {
      return true
    } else {
      return false
    }
  }
  
  public func updateProfile() {
    userProfileUpdatingState = .loading
    
    let newUserProfile = NewUserProfile(profileImage: editedUserProfile.profileImage,
                                        nickname: editedUserProfile.nickname.trimmingCharacters(in: .whitespaces),
                                        email: editedUserProfile.email,
                                        gender: editedUserProfile.gender,
                                        birthday: editedUserProfile.birthday)
    updateUserProfileUseCase.execute(newUserProfile: newUserProfile)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.userProfileUpdatingState = .failure(error: error)
        } else {
          self?.userProfileUpdatingState = .success
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
  }
  
  public func signOut() {
    signOutState = .loading
    
    signOutUseCase.execute()
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure = completion {
          self?.signOutState = .failure
        } else {
          UserSession.shared.clearSession()
          self?.signOutState = .success
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
  }
  
  public func withdraw() {
    withdrawState = .loading
    
    withdrawUseCase.execute()
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.withdrawState = .failure(error: error)
        } else {
          UserSession.shared.clearSession()
          self?.withdrawState = .success
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
  }
  
  func isNicknameValid() -> Bool {
    /// 정규식 패턴: 소문자, 대문자, 한글, 숫자, 언더바만 그리고 20자 이하로만 닉네임 허용
    let regex = "^[a-zA-Z0-9가-힣_]+$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let isLengthValid = editedUserProfile.nickname.count <= 20
    return isLengthValid && predicate.evaluate(with: editedUserProfile.nickname)
  }
}
