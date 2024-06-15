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

import UserSession

public final class ProfileViewModel: ObservableObject {
  
  // MARK: - Properties

  private let userProfileUseCase: UserProfileUseCase
  @Published private(set) var userProfile: UserProfile?
  @Published private(set) var userProfileFetchingState: UserProfileFetchingState = .idle
  enum UserProfileFetchingState: Equatable {
    case idle
    case loading
    case success
    case failure(error: UserProfileError)
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(userProfileUseCase: UserProfileUseCase) {
    self.userProfileUseCase = userProfileUseCase
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
        self?.userProfile = userProfile
      }
      .store(in: &cancellables)
  }
}
