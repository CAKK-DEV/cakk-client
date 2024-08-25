//
//  BusinessCertificationViewModel.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import DomainBusinessOwner

public final class BusinessCertificationViewModel: ObservableObject {
  
  
  // MARK: - Properties
  
  private let shopId: Int
  private let cakeShopOwnerVerificationUseCase: CakeShopOwnerVerificationUseCase
  @Published private(set) var verificationState: CertificationUploadState = .idle
  enum CertificationUploadState {
    case idle
    case imageRequired
    case contactRequired
    case loading
    case failure
    case serverError
    case success
  }
  
  @Published var selectedBusinessCertImage: UIImage?
  @Published var selectedIdCardImage: UIImage?
  @Published var contact: String = ""
  @Published var additionalMessage: String = ""
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    targetShopId: Int,
    cakeShopOwnerVerificationUseCase: CakeShopOwnerVerificationUseCase
  ) {
    self.shopId = targetShopId
    self.cakeShopOwnerVerificationUseCase = cakeShopOwnerVerificationUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func uploadCertifications() {
    verificationState = .success
//    guard let selectedBusinessCertImage, let selectedIdCardImage else {
//      verificationState = .imageRequired
//      return
//    }
//    
//    if contact.isEmpty {
//      verificationState = .contactRequired
//      return
//    }
//    
//    verificationState = .loading
//    
//    cakeShopOwnerVerificationUseCase.execute(shopId: shopId,
//                                       businessRegistrationImage: selectedBusinessCertImage,
//                                       idCardImage: selectedIdCardImage,
//                                       contact: contact,
//                                       message: additionalMessage)
//    .subscribe(on: DispatchQueue.global())
//    .receive(on: DispatchQueue.main)
//    .sink { [weak self] completion in
//      if case .failure(let error) = completion {
//        if error == .serverError {
//          self?.verificationState = .serverError
//        } else {
//          self?.verificationState = .failure
//        }
//        print(error.localizedDescription)
//      } else {
//        self?.verificationState = .success
//      }
//    } receiveValue: { _ in }
//    .store(in: &cancellables)
  }
}
