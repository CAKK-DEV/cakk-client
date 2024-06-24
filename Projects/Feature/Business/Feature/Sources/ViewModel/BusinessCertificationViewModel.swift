//
//  BusinessCertificationViewModel.swift
//  FeatureBusiness
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import DomainBusiness

public final class BusinessCertificationViewModel: ObservableObject {
  
  
  // MARK: - Properties
  
  private let shopId: Int
  private let uploadCertificationUseCase: UploadCertificationUseCase
  @Published private(set) var certificationUploadState: CertificationUploadState = .idle
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
    uploadCertificationUseCase: UploadCertificationUseCase
  ) {
    self.shopId = targetShopId
    self.uploadCertificationUseCase = uploadCertificationUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func uploadCertifications() {
    guard let selectedBusinessCertImage, let selectedIdCardImage else {
      certificationUploadState = .imageRequired
      return
    }
    
    if contact.isEmpty {
      certificationUploadState = .contactRequired
      return
    }
    
    certificationUploadState = .loading
    
    uploadCertificationUseCase.execute(shopId: shopId, 
                                       businessRegistrationImage: selectedBusinessCertImage,
                                       idCardImage: selectedIdCardImage,
                                       contact: contact,
                                       message: additionalMessage)
    .subscribe(on: DispatchQueue.global())
    .receive(on: DispatchQueue.main)
    .sink { [weak self] completion in
      if case .failure(let error) = completion {
        if error == .serverError {
          self?.certificationUploadState = .serverError
        } else {
          self?.certificationUploadState = .failure
        }
        print(error.localizedDescription)
      } else {
        self?.certificationUploadState = .success
      }
    } receiveValue: { _ in }
    .store(in: &cancellables)
  }
}
