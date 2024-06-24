//
//  MockUploadCertificationUseCase.swift
//  PreviewSupportBusiness
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import DomainBusiness

public struct MockUploadCertificationUseCase: UploadCertificationUseCase {
  
  // MARK: - Properties
  
  private let delay: TimeInterval
  private let scenario: Scenario
  public enum Scenario {
    case success
    case failure
    case serverError
  }
  
  
  // MARK: - Initializers
  
  public init(
    delay: TimeInterval = 1,
    scenario: Scenario = .success
  ) {
    self.delay = delay
    self.scenario = scenario
  }
  
  
  // MARK: - Public Methods
  
  public func execute(shopId: Int, businessRegistrationImage: UIImage, idCardImage: UIImage, contact: String, message: String) -> AnyPublisher<Void, UploadCertificationError> {
    switch scenario {
    case .success:
      Just(Void())
        .delay(for: .seconds(delay), scheduler: RunLoop.main)
        .setFailureType(to: UploadCertificationError.self)
        .eraseToAnyPublisher()
      
    case .failure:
      Fail(error: UploadCertificationError.failure)
        .eraseToAnyPublisher()
      
    case .serverError:
      Fail(error: UploadCertificationError.serverError)
        .eraseToAnyPublisher()
    }
  }
}
