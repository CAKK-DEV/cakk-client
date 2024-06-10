//
//  ProfileViewModel.swift
//  FeatureUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser

public final class ProfileViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private let userProfileUseCase: UserProfileUseCase
  private let updateUserProfileUseCase: UpdateUserProfileUseCase
  
  @Published private(set) var userProfile: UserProfile?
  @Published var editedUserProfile: UserProfile!
  
  @Published private(set) var userProfileFetchingState: UserProfileFetchingState = .idle
  enum UserProfileFetchingState: Equatable {
    case idle
    case loading
    case success
    case failure(error: UserProfileError)
  }
  
  @Published private(set) var userProfileUpdatingState: UserProfileUpdatingState = .idle
  enum UserProfileUpdatingState: Equatable {
    case idle
    case loading
    case success
    case failure(error: UserProfileError)
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    userProfileUseCase: UserProfileUseCase,
    updateUserProfileUseCase: UpdateUserProfileUseCase
  ) {
    self.userProfileUseCase = userProfileUseCase
    self.updateUserProfileUseCase = updateUserProfileUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchUserProfile() {
    userProfileFetchingState = .loading
    
    userProfileUseCase.execute()
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        print(completion)
        if case .failure(let error) = completion {
          self?.userProfileFetchingState = .failure(error: error)
        } else {
          self?.userProfileFetchingState = .success
        }
      } receiveValue: { [weak self] userProfile in
        self?.userProfile = userProfile
        self?.editedUserProfile = userProfile // 원본 복사
      }
      .store(in: &cancellables)
  }
  
  public func profileHasChanges() -> Bool {
    return userProfile != editedUserProfile
  }
  
  public func restoreChanges() {
    editedUserProfile = userProfile
  }
  
  public func updateProfile() {
    userProfileUpdatingState = .loading
    
    let newUserProfile = NewUserProfile(profileImageUrl: editedUserProfile.profileImageUrl,
                                        nickName: editedUserProfile.nickname,
                                        email: editedUserProfile.email,
                                        gender: editedUserProfile.gender,
                                        birthday: editedUserProfile.birthday)
    updateUserProfileUseCase.execute(newUserProfile: newUserProfile)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.userProfileUpdatingState = .failure(error: error)
        } else {
          self?.userProfile = self?.editedUserProfile
          self?.userProfileUpdatingState = .success
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
  }
}
