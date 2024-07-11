//
//  UpdateProfileUseCaseImpl.swift
//  NetworkUser
//
//  Created by 이승기 on 6/10/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainUser
import NetworkImage

import UserSession

public final class UpdateUserProfileUseCaseImpl: UpdateUserProfileUseCase {
  
  // MARK: - Properties
  
  private let userProfileRepository: UserProfileRepository
  private let imageUploadRepository: ImageUploadRepository
  
  
  // MARK: - Initializers
  
  public init(userProfileRepository: UserProfileRepository, imageUploadRepository: ImageUploadRepository) {
    self.userProfileRepository = userProfileRepository
    self.imageUploadRepository = imageUploadRepository
  }
  
  
  // MARK: - Public Methods
  
  public func execute(newUserProfile: DomainUser.NewUserProfile) -> AnyPublisher<Void, UserProfileError> {
    if let accessToken = UserSession.shared.accessToken {
      switch newUserProfile.profileImage {
      case .delete, .none:
        return userProfileRepository.updateUserProfile(profileImageUrl: nil,
                                                       nickName: newUserProfile.nickname,
                                                       email: newUserProfile.email,
                                                       gender: newUserProfile.gender,
                                                       birthday: newUserProfile.birthday,
                                                       accessToken: accessToken)
        
      case .new(let image):
        return imageUploadRepository.uploadImage(image: image)
          .mapError { error in
            switch error {
            case .imageConvertError, .failure:
              return UserProfileError.imageUploadFailure
            }
          }
          .flatMap { [userProfileRepository] imageUrl -> AnyPublisher<Void, UserProfileError> in
            return userProfileRepository.updateUserProfile(profileImageUrl: imageUrl,
                                                           nickName: newUserProfile.nickname,
                                                           email: newUserProfile.email,
                                                           gender: newUserProfile.gender,
                                                           birthday: newUserProfile.birthday,
                                                           accessToken: accessToken)
          }
          .eraseToAnyPublisher()
        
      case .original(let imageUrl):
        return userProfileRepository.updateUserProfile(profileImageUrl: imageUrl,
                                                       nickName: newUserProfile.nickname,
                                                       email: newUserProfile.email,
                                                       gender: newUserProfile.gender,
                                                       birthday: newUserProfile.birthday,
                                                       accessToken: accessToken)
      }
    } else {
      return Fail(error: UserProfileError.sessionExpired)
        .eraseToAnyPublisher()
    }
  }
}
