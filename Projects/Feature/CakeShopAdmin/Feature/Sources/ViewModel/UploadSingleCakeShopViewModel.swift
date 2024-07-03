//
//  UploadSingleCakeShopViewModel.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/27/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine
import DomainCakeShop

public final class UploadSingleCakeShopViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private let uploadCakeShopUseCase: UploadCakeShopUseCase
  
  @Published var shopName: String = ""
  @Published var shopBio: String = ""
  @Published var shopDescription: String = ""
  
  @Published var shopAddress: String = ""
  @Published var latitude: String = ""
  @Published var longitude: String = ""
  
  @Published var externalShopLinks: [ExternalShopLink] = [
    .init(linkType: .kakaotalk, linkPath: ""),
    .init(linkType: .instagram, linkPath: ""),
    .init(linkType: .web, linkPath: "")
  ]
  
  @Published var workingDaysWithTime: [WorkingDayWithTime] = [
    WorkingDayWithTime(workingDay: .sun, startTime: "", endTime: ""),
    WorkingDayWithTime(workingDay: .mon, startTime: "", endTime: ""),
    WorkingDayWithTime(workingDay: .tue, startTime: "", endTime: ""),
    WorkingDayWithTime(workingDay: .wed, startTime: "", endTime: ""),
    WorkingDayWithTime(workingDay: .thu, startTime: "", endTime: ""),
    WorkingDayWithTime(workingDay: .fri, startTime: "", endTime: ""),
    WorkingDayWithTime(workingDay: .sat, startTime: "", endTime: "")
  ]
  
  @Published var businessNumber: String = ""
  @Published private(set) var cakeShopUploadState: CakeShopUploadState = .idle
  enum CakeShopUploadState {
    case idle
    case loading
    case failure
    case success
    case invalidCoordinate
    case wrongWorkingDayFormat
    case emptyRequiredField
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(uploadCakeShopUseCase: UploadCakeShopUseCase) {
    self.uploadCakeShopUseCase = uploadCakeShopUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func uploadCakeShop() {
    if shopName.isEmpty || shopAddress.isEmpty || latitude.isEmpty || longitude.isEmpty {
      cakeShopUploadState = .emptyRequiredField
      return
    }
    
    guard let latitude = Double(latitude),
          let longitude = Double(longitude) else {
      cakeShopUploadState = .invalidCoordinate
      return
    }
    
    // Validate workingDaysWithTime format
    for day in workingDaysWithTime {
      if !day.startTime.isEmpty && !isValidTimeFormat(day.startTime) {
        cakeShopUploadState = .wrongWorkingDayFormat
        return
      }
      if !day.endTime.isEmpty && !isValidTimeFormat(day.endTime) {
        cakeShopUploadState = .wrongWorkingDayFormat
        return
      }
    }
    
    // Filter workingDaysWithTime to include only those with non-empty startTime and endTime
    let validWorkingDaysWithTime = workingDaysWithTime.filter { !$0.startTime.isEmpty && !$0.endTime.isEmpty }
    
    let validExternalLinks = externalShopLinks.filter { !$0.linkPath.isEmpty }
    
    uploadCakeShopUseCase.execute(name: shopName.trimmingCharacters(in: .whitespaces),
                                  bio: shopBio.isEmpty ? nil : shopBio.trimmingCharacters(in: .whitespaces),
                                  description: shopDescription.isEmpty ? nil : shopDescription.trimmingCharacters(in: .whitespaces),
                                  businessNumber: businessNumber.isEmpty ? nil : businessNumber.trimmingCharacters(in: .whitespaces),
                                  address: shopAddress.trimmingCharacters(in: .whitespaces),
                                  latitude: latitude,
                                  longitude: longitude,
                                  workingDaysWithTime: validWorkingDaysWithTime,
                                  externalLinks: validExternalLinks)
    .sink { [weak self] completion in
      if case .failure(let error) = completion {
        self?.cakeShopUploadState = .failure
        print(error.localizedDescription)
      } else {
        self?.cakeShopUploadState = .success
      }
    } receiveValue: { _ in }
      .store(in: &cancellables)
  }
  
  public func resetFields() {
    shopName = ""
    shopBio = ""
    shopDescription = ""
    shopAddress = ""
    latitude = ""
    longitude = ""
    businessNumber = ""
    workingDaysWithTime = [
      WorkingDayWithTime(workingDay: .sun, startTime: "", endTime: ""),
      WorkingDayWithTime(workingDay: .mon, startTime: "", endTime: ""),
      WorkingDayWithTime(workingDay: .tue, startTime: "", endTime: ""),
      WorkingDayWithTime(workingDay: .wed, startTime: "", endTime: ""),
      WorkingDayWithTime(workingDay: .thu, startTime: "", endTime: ""),
      WorkingDayWithTime(workingDay: .fri, startTime: "", endTime: ""),
      WorkingDayWithTime(workingDay: .sat, startTime: "", endTime: "")
    ]
    externalShopLinks = [
      .init(linkType: .kakaotalk, linkPath: ""),
      .init(linkType: .instagram, linkPath: ""),
      .init(linkType: .web, linkPath: "")
    ]
  }
  
  // MARK: - Private Methods
  
  private func isValidTimeFormat(_ time: String) -> Bool {
      let timeRegex = "^([01]\\d|2[0-4]):([0-5]\\d)$"
      return NSPredicate(format: "SELF MATCHES %@", timeRegex).evaluate(with: time)
  }
}
