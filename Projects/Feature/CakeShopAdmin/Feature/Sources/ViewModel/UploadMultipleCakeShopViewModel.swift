//
//  UploadMultipleCakeShopViewModel.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/28/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import CommonDomain
import DomainCakeShop

public final class UploadMultipleCakeShopViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private let uploadCakeShopUseCase: UploadCakeShopUseCase
  @Published var jsonRawString: String = ""
  
  @Published private(set) var cakeShopUploadingState: CakeShopUploadingState = .idle
  enum CakeShopUploadingState {
    case idle
    case loading
    case failure
    case jsonParsingFailure
    case success
  }
  
  private struct CakeShop: Codable {
    let person: String
    let location: String
    let latitude: Double
    let longitude: Double
    let days: [String]
    let startTimes: [String]
    let endTimes: [String]
    let url: String
    let kakaoUrl: String
    let homePage: String
    let instagramUrl: String
    let name: String
    let bio: String
    let description: String
  }
  
  private var cancenllables = Set<AnyCancellable>()
  

  // MARK: - Initializers
  
  public init(uploadCakeShopUseCase: UploadCakeShopUseCase) {
    self.uploadCakeShopUseCase = uploadCakeShopUseCase
  }
  
  
  // MARK: - Public Methods
  
  // TODO: 네트워크 쪽으로 파싱 및 업로드 로직 옮기기
  
  public func upload() {
    cakeShopUploadingState = .loading
    
    guard let cakeShops = parseJSONData(jsonRawString) else {
      cakeShopUploadingState = .jsonParsingFailure
      return
    }
    
    uploadCakeShops(cakeShops: cakeShops)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.cakeShopUploadingState = .failure
          print(error.localizedDescription)
        } else {
          self?.cakeShopUploadingState = .success
        }
      } receiveValue: { _ in }
      .store(in: &cancenllables)
  }
  
  
  // MARK: - Private Methods
  
  private func parseJSONData(_ jsonString: String) -> [CakeShop]? {
    guard let jsonData = jsonString.data(using: .utf8) else { return nil }
    
    let decoder = JSONDecoder()
    do {
      let cakeShops = try decoder.decode([CakeShop].self, from: jsonData)
      return cakeShops
    } catch {
      print("Error decoding JSON: \(error)")
      return nil
    }
  }
  
  private func uploadCakeShops(cakeShops: [CakeShop]) -> AnyPublisher<Void, CakeShopError> {
    let publishers = cakeShops.compactMap { cakeShop -> AnyPublisher<Void, CakeShopError>? in
      let workingDaysWithTime: [WorkingDayWithTime] = zip(cakeShop.days, zip(cakeShop.startTimes, cakeShop.endTimes)).compactMap { day, times in
        let workingDay = WorkingDay(rawValue: day)!
        return WorkingDayWithTime(workingDay: workingDay, startTime: times.0, endTime: times.1)
      }
      
      let externalLinks: [ExternalShopLink] = [
        ExternalShopLink(linkType: .web, linkPath: cakeShop.url),
        ExternalShopLink(linkType: .kakaotalk, linkPath: cakeShop.kakaoUrl),
        ExternalShopLink(linkType: .instagram, linkPath: cakeShop.instagramUrl)
      ].filter { !$0.linkPath.isEmpty }
      
      let truncatedBio = truncateText(cakeShop.bio, toLength: 30)
      let truncatedDescription = truncateText(cakeShop.description, toLength: 470)
      
      return uploadCakeShopUseCase.execute(
        name: cakeShop.name,
        bio: truncatedBio.isEmpty ? nil : truncatedBio,
        description: truncatedDescription.isEmpty ? nil : truncatedDescription,
        businessNumber: nil,
        address: cakeShop.location,
        latitude: cakeShop.latitude,
        longitude: cakeShop.longitude,
        workingDaysWithTime: workingDaysWithTime,
        externalLinks: externalLinks
      ).eraseToAnyPublisher()
    }
    
    return Publishers.MergeMany(publishers)
      .collect()
      .map { _ in () }
      .eraseToAnyPublisher()
  }
  
  private func truncateText(_ text: String, toLength maxLength: Int) -> String {
      var currentLength = 0
      var truncatedBio = ""

      for char in text {
          currentLength += char.unicodeScalars.count > 1 ? 2 : 1

          if currentLength > maxLength {
              break
          }

          truncatedBio.append(char)
      }

      return truncatedBio
  }
}
