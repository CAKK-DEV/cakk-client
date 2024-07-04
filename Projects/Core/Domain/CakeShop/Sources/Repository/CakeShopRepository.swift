//
//  CakeShopRepository.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import CommonDomain

public protocol CakeShopRepository {
  func fetchImageDetail(cakeImageId: Int) -> AnyPublisher<CakeImageDetail, CakeShopError>
  
  // MARK: - Upload
  func uploadCakeShop(name: String, bio: String?, description: String?, businessNumber: String?, address: String, latitude: Double, longitude: Double, workingDaysWithTime: [WorkingDayWithTime], externalLinks: [ExternalShopLink]) -> AnyPublisher<Void, CakeShopError>
  func uploadCakeImage(cakeShopId: Int, image: UIImage, categories: [CakeCategory], tags: [String], accessToken: String) -> AnyPublisher<Void, CakeShopError>
  
  // MARK: - Edit
  func editShopBasicInfo(shopId: Int, newCakeShopBasicInfo: NewCakeShopBasicInfo, accessToken: String) -> AnyPublisher<Void, CakeShopError>
  func editExternalLink(cakeShopId: Int, instaUrl: String?, kakaoUrl: String?, webUrl: String?, accessToken: String) -> AnyPublisher<Void, CakeShopError>
  func editWorkingDaysWithTime(cakeShopId: Int, workingDaysWithTime: [WorkingDayWithTime], accessToken: String) -> AnyPublisher<Void, CakeShopError>
  func editShopAddress(cakeShopId: Int, address: String, latitude: Double, longitude: Double, accessToken: String) -> AnyPublisher<Void, CakeShopError>
  func editCakeImage(cakeImageId: Int, imageUrl: String, categories: [CakeCategory], tags: [String], accessToken: String) -> AnyPublisher<Void, CakeShopError>
  func deleteCakeImage(cakeImageId: Int, accessToken: String) -> AnyPublisher<Void, CakeShopError>
}
