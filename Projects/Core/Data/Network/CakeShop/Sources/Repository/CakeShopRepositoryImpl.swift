//
//  CakeShopRepositoryImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/27/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import DomainCakeShop

import Moya
import CombineMoya

public final class CakeShopRepositoryImpl: CakeShopRepository {
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<CakeShopAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<CakeShopAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  public func uploadCakeShop(name: String, 
                             bio: String?,
                             description: String?,
                             businessNumber: String?,
                             address: String,
                             latitude: Double,
                             longitude: Double
                             , workingDaysWithTime: [DomainCakeShop.WorkingDayWithTime],
                             externalLinks: [ExternalShopLink]) -> AnyPublisher<Void, CakeShopError> {
    let newCakeShopDTO = NewCakeShopDTO(businessNumber: businessNumber,
                                        operationDays: workingDaysWithTime.map { $0.toDTO() },
                                        shopName: name,
                                        shopBio: bio,
                                        shopDescription: description,
                                        shopAddress: address,
                                        latitude: latitude,
                                        longitude: longitude,
                                        links: externalLinks.map { $0.toDTO() })
    print(newCakeShopDTO)
    return provider.requestPublisher(.uploadCakeShop(newCakeShopDTO))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(NewCakeShopResponseDTO.self, from: response.data)
          guard let data = decodedResponse.data else {
            throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          print("\(data.cakeShopId) 업로드 성공 완료")
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(NewCakeShopResponseDTO.self, from: response.data)
          throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          return networkError.toDomainError()
        } else {
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func editShopBasicInfo(shopId: Int, newCakeShopBasicInfo: NewCakeShopBasicInfo, accessToken: String) -> AnyPublisher<Void, DomainCakeShop.CakeShopError> {
    uploadProfileImageIfNeeded(image: newCakeShopBasicInfo.profileImage)
      .flatMap { [provider] profileImageUrl -> AnyPublisher<Response, CakeShopError> in
        provider.requestPublisher(.updateCakeShopBasicInfo(shopId: shopId,
                                                           thumbnailUrl: profileImageUrl,
                                                           shopName: newCakeShopBasicInfo.shopName,
                                                           shopBio: newCakeShopBasicInfo.shopBio,
                                                           shopDescription: newCakeShopBasicInfo.shopDescription,
                                                           accessToken: accessToken))
          .mapError { _ in CakeShopError.failure }
          .eraseToAnyPublisher()
      }
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(BaseCakeShopNetworkResponseDTO.self, from: response.data)
          throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          return networkError.toDomainError()
        } else {
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func editExternalLink(cakeShopId: Int, instaUrl: String?, kakaoUrl: String?, webUrl: String?, accessToken: String) -> AnyPublisher<Void, DomainCakeShop.CakeShopError> {
    provider.requestPublisher(.updateExternalLinks(shopId: cakeShopId, instaUrl: instaUrl, kakaoUrl: kakaoUrl, webUrl: webUrl, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(BaseCakeShopNetworkResponseDTO.self, from: response.data)
          throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          return networkError.toDomainError()
        } else {
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func editWorkingDaysWithTime(cakeShopId: Int, workingDaysWithTime: [DomainCakeShop.WorkingDayWithTime], accessToken: String) -> AnyPublisher<Void, DomainCakeShop.CakeShopError> {
    provider.requestPublisher(.updateOperationDays(shopId: cakeShopId, operationDays: workingDaysWithTime.toDTO(), accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(BaseCakeShopNetworkResponseDTO.self, from: response.data)
          throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          return networkError.toDomainError()
        } else {
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func editShopAddress(cakeShopId: Int, address: String, latitude: Double, longitude: Double, accessToken: String) -> AnyPublisher<Void, DomainCakeShop.CakeShopError> {
    provider.requestPublisher(.updateShopAddress(shopId: cakeShopId, address: address, latitude: latitude, longitude: longitude, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(BaseCakeShopNetworkResponseDTO.self, from: response.data)
          throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          return networkError.toDomainError()
        } else {
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func uploadCakeImage(cakeShopId: Int, image: UIImage, categories: [DomainCakeShop.CakeCategory], tags: [String], accessToken: String) -> AnyPublisher<Void, DomainCakeShop.CakeShopError> {
    uploadImage(image: image)
      .flatMap { [provider] imageUrl -> AnyPublisher<Void, CakeShopError> in
        let newCakeImage = NewCakeImageDTO(cakeImageUrl: imageUrl,
                                           cakeDesignCategories: categories.map { $0.toDTO() },
                                           tagNames: tags)
        return provider.requestPublisher(.uploadCakeImage(shopId: cakeShopId,
                                                          newCakeImage: newCakeImage,
                                                          accessToken: accessToken))
        .tryMap { response in
          switch response.statusCode {
          case 200..<300:
            return Void()
            
          default:
            let decodedResponse = try JSONDecoder().decode(BaseCakeShopNetworkResponseDTO.self, from: response.data)
            throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
        }
        .mapError { error in
          if let networkError = error as? CakeShopNetworkError {
            return networkError.toDomainError()
          } else {
            return CakeShopNetworkError.error(for: error).toDomainError()
          }
        }
        .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  public func editCakeImage(cakeImageId: Int, imageUrl: String, categories: [DomainCakeShop.CakeCategory], tags: [String], accessToken: String) -> AnyPublisher<Void, DomainCakeShop.CakeShopError> {
    let newCakeImage = NewCakeImageDTO(cakeImageUrl: imageUrl,
                                       cakeDesignCategories: categories.map { $0.toDTO() },
                                       tagNames: tags)
    return provider.requestPublisher(.editCakeImage(imageId: cakeImageId,
                                                    newCakeImage: newCakeImage,
                                                    accessToken: accessToken))
    .tryMap { response in
      switch response.statusCode {
      case 200..<300:
        return Void()
        
        default:
          let decodedResponse = try JSONDecoder().decode(BaseCakeShopNetworkResponseDTO.self, from: response.data)
          throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          return networkError.toDomainError()
        } else {
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func deleteCakeImage(cakeImageId: Int, accessToken: String) -> AnyPublisher<Void, DomainCakeShop.CakeShopError> {
    provider.requestPublisher(.deleteCakeImage(imageId: cakeImageId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(BaseCakeShopNetworkResponseDTO.self, from: response.data)
          throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          return networkError.toDomainError()
        } else {
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchImageDetail(cakeImageId: Int) -> AnyPublisher<DomainCakeShop.CakeImageDetail, DomainCakeShop.CakeShopError> {
    provider.requestPublisher(.fetchCakeImageDetail(imageId: cakeImageId))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(CakeImageDetailResponseDTO.self, from: response.data)
          guard let data = decodedResponse.data else {
            throw CakeShopNetworkError.dataIsNil
          }
          
          return data.toDomain()
          
        default:
          let decodedResponse = try JSONDecoder().decode(CakeImageDetailResponseDTO.self, from: response.data)
          throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          return networkError.toDomainError()
        } else {
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  
  // MARK: - Private Methods
  
  private func uploadProfileImageIfNeeded(image: NewCakeShopBasicInfo.ProfileImage) -> AnyPublisher<String?, CakeShopError> {
    switch image {
    case .delete, .none:
      return Just(nil)
        .setFailureType(to: CakeShopError.self)
        .eraseToAnyPublisher()
      
    case .original(let originalImageUrl):
      return Just(originalImageUrl)
        .setFailureType(to: CakeShopError.self)
        .eraseToAnyPublisher()
      
    case .new(let image):
      return provider.requestPublisher(.requestPresignedUrl)
        .tryMap { response -> (String, String) in
          switch response.statusCode {
          case 200..<300:
            let decodedResponse = try JSONDecoder().decode(PresignedUrlResponseDTO.self, from: response.data)
            let presignedUrl = decodedResponse.data.presignedUrl
            let imageUrl = decodedResponse.data.imageUrl
            return (presignedUrl, imageUrl)
            
          default:
            throw CakeShopError.imageUploadFailure
          }
        }
        .flatMap { [provider] (presignedUrl, imageUrl) -> AnyPublisher<String?, Error> in
          // TODO: - 이미지 Webp로 변환
          guard let data = image.jpegData(compressionQuality: 1) else {
            return Fail(error: CakeShopError.imageUploadFailure).eraseToAnyPublisher()
          }
          /// 이미지를 webP 형식으로 변환 후 PresignedURL에 업로드 합니다.
//          SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
//          guard let data = image.sd_imageData(as: .webP, compressionQuality: 1) else {
//            return Fail(error: UserProfileError.imageUploadFailure).eraseToAnyPublisher()
//          }
          
          return provider.requestPublisher(.uploadPresignedImage(presignedUrl: presignedUrl, image: data))
          .map { _ in imageUrl }
          .mapError { _ in CakeShopError.imageUploadFailure }
          .eraseToAnyPublisher()
        }
        .mapError { _ in CakeShopError.imageUploadFailure }
        .eraseToAnyPublisher()
    }
  }
  
  /// PresignedUrl 요청 후 해당 url에 이미지를 업로드 한 후 imageUrl을 반환합니다.
  private func uploadImage(image: UIImage) -> AnyPublisher<String, CakeShopError> {
    provider.requestPublisher(.requestPresignedUrl)
      .tryMap { response -> (String, String) in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(PresignedUrlResponseDTO.self, from: response.data)
          let presignedUrl = decodedResponse.data.presignedUrl
          let imageUrl = decodedResponse.data.imageUrl
          return (presignedUrl, imageUrl)
          
        default:
          throw CakeShopError.imageUploadFailure
        }
      }
      .flatMap { [provider] (presignedUrl, imageUrl) -> AnyPublisher<String, Error> in
        // TODO: - Webp로 변환하도록 변경
        guard let data = image.jpegData(compressionQuality: 1) else {
          return Fail(error: CakeShopError.imageUploadFailure).eraseToAnyPublisher()
        }
        /// 이미지를 webP 형식으로 변환 후 PresignedURL에 업로드 합니다.
//        SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
//        guard let data = image.sd_imageData(as: .webP, compressionQuality: 1) else {
//          return Fail(error: UploadCertificationError.imageUploadFailure).eraseToAnyPublisher()
//        }
        
        return provider.requestPublisher(.uploadPresignedImage(presignedUrl: presignedUrl, image: data))
        .map { _ in imageUrl }
        .mapError { _ in CakeShopError.imageUploadFailure }
        .eraseToAnyPublisher()
      }
      .mapError { _ in CakeShopError.failure }
      .eraseToAnyPublisher()
  }
}
