//
//  CakeShopRepositoryImpl.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/27/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import CommonDomain
import DomainCakeShop

import Moya
import CombineMoya

import Logger

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
                             longitude: Double,
                             workingDaysWithTime: [WorkingDayWithTime],
                             externalLinks: [ExternalShopLink]) -> AnyPublisher<Void, CakeShopError> {
    Loggers.networkCakeShop.info("새로운 케이크샵을 업로드 시작합니다.", category: .network)
    
    let newCakeShopDTO = NewCakeShopDTO(businessNumber: businessNumber,
                                        operationDays: workingDaysWithTime.map { $0.toDTO() },
                                        shopName: name,
                                        shopBio: bio,
                                        shopDescription: description,
                                        shopAddress: address,
                                        latitude: latitude,
                                        longitude: longitude,
                                        links: externalLinks.map { $0.toDTO() })
    return provider.requestPublisher(.uploadCakeShop(newCakeShopDTO))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(NewCakeShopResponseDTO.self, from: response.data)
          guard let data = decodedResponse.data else {
            Loggers.networkCakeShop.error("결과 데이터가 비어있음. (업로드가 완료되면 케이크샵 id를 가진 정보가 옵니다)", category: .network)
            throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
          }
          
          Loggers.networkCakeShop.info("업로드 성공. cakeShopId: \(data.cakeShopId)", category: .network)
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(NewCakeShopResponseDTO.self, from: response.data)
          throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          Loggers.networkCakeShop.error("네트워크 에러 발생 \(networkError.localizedDescription)", category: .network)
          return networkError.toDomainError()
        } else {
          Loggers.networkCakeShop.error("예측되지 못한 에러 발생 \(error.localizedDescription)", category: .network)
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func editShopBasicInfo(shopId: Int, profileImageUrl: String?, shopName: String, shopBio: String, shopDescription: String, accessToken: String) -> AnyPublisher<Void, DomainCakeShop.CakeShopError> {
    Loggers.networkCakeShop.info("케이크샵 기본 정보를 수정을 시작합니다.", category: .network)
    
    return provider.requestPublisher(.updateCakeShopBasicInfo(shopId: shopId,
                                                       thumbnailUrl: profileImageUrl,
                                                       shopName: shopName,
                                                       shopBio: shopBio,
                                                       shopDescription: shopDescription,
                                                       accessToken: accessToken))
    .tryMap { response in
      switch response.statusCode {
      case 200..<300:
        Loggers.networkCakeShop.info("케이크샵 기본정보 수정이 완료되었습니다.", category: .network)
        return Void()
        
      default:
        let decodedResponse = try JSONDecoder().decode(BaseCakeShopNetworkResponseDTO.self, from: response.data)
        throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
      }
    }
    .mapError { error in
      if let networkError = error as? CakeShopNetworkError {
        Loggers.networkCakeShop.error("네트워크 에러 발생. \(networkError.localizedDescription)", category: .network)
        return networkError.toDomainError()
      } else {
        Loggers.networkCakeShop.error("예측되지 못한 못한 에러 발생 \(error.localizedDescription)", category: .network)
        return CakeShopNetworkError.error(for: error).toDomainError()
      }
    }
    .eraseToAnyPublisher()
  }
  
  public func editExternalLink(cakeShopId: Int, instaUrl: String?, kakaoUrl: String?, webUrl: String?, accessToken: String) -> AnyPublisher<Void, DomainCakeShop.CakeShopError> {
    Loggers.networkCakeShop.info("케이크샵 외부링크 수정을 시작합니다.", category: .network)
    
    return provider.requestPublisher(.updateExternalLinks(shopId: cakeShopId, instaUrl: instaUrl, kakaoUrl: kakaoUrl, webUrl: webUrl, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          Loggers.networkCakeShop.info("케이크샵 외부링크를 수정하였습니다.", category: .network)
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(BaseCakeShopNetworkResponseDTO.self, from: response.data)
          throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          Loggers.networkCakeShop.error("네트워크 에러 발생. \(networkError.localizedDescription)", category: .network)
          return networkError.toDomainError()
        } else {
          Loggers.networkCakeShop.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func editWorkingDaysWithTime(cakeShopId: Int, workingDaysWithTime: [WorkingDayWithTime], accessToken: String) -> AnyPublisher<Void, CakeShopError> {
    Loggers.networkCakeShop.info("케이크샵 가게 영업일을 수정을 시작합니다.", category: .network)
    
    return provider.requestPublisher(.updateOperationDays(shopId: cakeShopId, operationDays: workingDaysWithTime.toDTO(), accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          Loggers.networkCakeShop.info("케이크샵 가게 영업일 수정에 성공하였습니다.", category: .network)
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(BaseCakeShopNetworkResponseDTO.self, from: response.data)
          throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          Loggers.networkCakeShop.error("네트워크 에러 발생. \(networkError.localizedDescription)", category: .network)
          return networkError.toDomainError()
        } else {
          Loggers.networkCakeShop.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func editShopAddress(cakeShopId: Int, address: String, latitude: Double, longitude: Double, accessToken: String) -> AnyPublisher<Void, DomainCakeShop.CakeShopError> {
    Loggers.networkCakeShop.info("케이크샵 주소 수정을 시작합니다.", category: .network)
    
    return provider.requestPublisher(.updateShopAddress(shopId: cakeShopId, address: address, latitude: latitude, longitude: longitude, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          Loggers.networkCakeShop.info("케이크샵 주소 수정에 성공하였습니다.", category: .network)
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(BaseCakeShopNetworkResponseDTO.self, from: response.data)
          throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          Loggers.networkCakeShop.error("네트워크 에러 발생. \(networkError.localizedDescription)", category: .network)
          return networkError.toDomainError()
        } else {
          Loggers.networkCakeShop.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func uploadCakeImage(cakeShopId: Int, imageUrl: String, categories: [CakeCategory], tags: [String], accessToken: String) -> AnyPublisher<Void, CakeShopError> {
    Loggers.networkCakeShop.info("케이크 이미지 업로드를 시작합니다.", category: .network)
    
    let newCakeImage = NewCakeImageDTO(cakeImageUrl: imageUrl,
                                       cakeDesignCategories: categories.map { $0.toDTO() },
                                       tagNames: tags)
    return provider.requestPublisher(.uploadCakeImage(shopId: cakeShopId,
                                                      newCakeImage: newCakeImage,
                                                      accessToken: accessToken))
    .tryMap { response in
      switch response.statusCode {
      case 200..<300:
        Loggers.networkCakeShop.info("케이크 이미지 업로드에 성공하였습니다.", category: .network)
        return Void()
        
      default:
        let decodedResponse = try JSONDecoder().decode(BaseCakeShopNetworkResponseDTO.self, from: response.data)
        throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
      }
    }
    .mapError { error in
      if let networkError = error as? CakeShopNetworkError {
        Loggers.networkCakeShop.error("네트워크 에러 발생. \(networkError.localizedDescription)", category: .network)
        return networkError.toDomainError()
      } else {
        Loggers.networkCakeShop.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
        return CakeShopNetworkError.error(for: error).toDomainError()
      }
    }
    .eraseToAnyPublisher()
  }
  
  public func editCakeImage(cakeImageId: Int, imageUrl: String, categories: [CakeCategory], tags: [String], accessToken: String) -> AnyPublisher<Void, CakeShopError> {
    Loggers.networkCakeShop.info("케이크 이미지를 수정합니다.", category: .network)
    
    let newCakeImage = NewCakeImageDTO(cakeImageUrl: imageUrl,
                                       cakeDesignCategories: categories.map { $0.toDTO() },
                                       tagNames: tags)
    return provider.requestPublisher(.editCakeImage(imageId: cakeImageId,
                                                    newCakeImage: newCakeImage,
                                                    accessToken: accessToken))
    .tryMap { response in
      switch response.statusCode {
      case 200..<300:
        Loggers.networkCakeShop.info("케이크 이미지 업로드에 성공하였습니다.", category: .network)
        return Void()
        
        default:
          let decodedResponse = try JSONDecoder().decode(BaseCakeShopNetworkResponseDTO.self, from: response.data)
          throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          Loggers.networkCakeShop.error("네트워크 에러 발생. \(networkError.localizedDescription)", category: .network)
          return networkError.toDomainError()
        } else {
          Loggers.networkCakeShop.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func deleteCakeImage(cakeImageId: Int, accessToken: String) -> AnyPublisher<Void, DomainCakeShop.CakeShopError> {
    Loggers.networkCakeShop.info("케이크 이미지를 삭제합니다.", category: .network)
    
    return provider.requestPublisher(.deleteCakeImage(imageId: cakeImageId, accessToken: accessToken))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          Loggers.networkCakeShop.info("케이크 이미지 삭제에 성공하였습니다.", category: .network)
          return Void()
          
        default:
          let decodedResponse = try JSONDecoder().decode(BaseCakeShopNetworkResponseDTO.self, from: response.data)
          throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          Loggers.networkCakeShop.error("네트워크 에러 발생. \(networkError.localizedDescription)", category: .network)
          return networkError.toDomainError()
        } else {
          Loggers.networkCakeShop.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
  
  public func fetchImageDetail(cakeImageId: Int) -> AnyPublisher<DomainCakeShop.CakeImageDetail, DomainCakeShop.CakeShopError> {
    Loggers.networkCakeShop.info("케이크 이미지 디테일을 불러옵니다.", category: .network)
    
    return provider.requestPublisher(.fetchCakeImageDetail(imageId: cakeImageId))
      .tryMap { response in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(CakeImageDetailResponseDTO.self, from: response.data)
          guard let data = decodedResponse.data else {
            throw CakeShopNetworkError.dataIsNil
          }
          
          Loggers.networkCakeShop.info("케이크 이미지 불러오기에 성공하였습니다.\n\(data)", category: .network)
          return data.toDomain()
          
        default:
          let decodedResponse = try JSONDecoder().decode(CakeImageDetailResponseDTO.self, from: response.data)
          throw CakeShopNetworkError.customError(for: decodedResponse.returnCode, message: decodedResponse.returnMessage)
        }
      }
      .mapError { error in
        if let networkError = error as? CakeShopNetworkError {
          Loggers.networkCakeShop.error("네트워크 에러 발생. \(networkError.localizedDescription)", category: .network)
          return networkError.toDomainError()
        } else {
          Loggers.networkCakeShop.error("예측되지 못한 에러 발생. \(error.localizedDescription)", category: .network)
          return CakeShopNetworkError.error(for: error).toDomainError()
        }
      }
      .eraseToAnyPublisher()
  }
}
