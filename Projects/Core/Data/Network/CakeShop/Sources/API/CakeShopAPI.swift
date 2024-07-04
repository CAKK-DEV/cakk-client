//
//  CakeShopAPI.swift
//  NetworkCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Moya

public enum CakeShopAPI {
  /// cakeImageId파라미터가 있다면 케이크 이미지 조회수를 올립니다
  case fetchCakeShopQuickInfo(shopId: Int, cakeImageId: Int?)
  
  case fetchCakeShopDetail(shopId: Int)
  case fetchAdditionalInfo(shopId: Int)
  
  case uploadCakeShop(NewCakeShopDTO)
  case updateCakeShopBasicInfo(shopId: Int, thumbnailUrl: String?, shopName: String, shopBio: String?, shopDescription: String?, accessToken: String)
  case updateExternalLinks(shopId: Int, instaUrl: String?, kakaoUrl: String?, webUrl: String?, accessToken: String)
  case updateOperationDays(shopId: Int, operationDays: OperationDaysDTO, accessToken: String)
  case updateShopAddress(shopId: Int, address: String, latitude: Double, longitude: Double, accessToken: String)
  
  case fetchCakeImageDetail(imageId: Int)
  case uploadCakeImage(shopId: Int, newCakeImage: NewCakeImageDTO, accessToken: String)
  case editCakeImage(imageId: Int, newCakeImage: NewCakeImageDTO, accessToken: String)
  case deleteCakeImage(imageId: Int, accessToken: String)
  
  case requestPresignedUrl
  case uploadPresignedImage(presignedUrl: String, image: Data)
  case isOwned(shopId: Int, accessToken: String)
}

extension CakeShopAPI: TargetType {
  public var baseURL: URL {
    switch self {
    case .uploadPresignedImage(let presignedUrl, _):
      return URL(string: presignedUrl)!
      
    default:
      let baseURLString = Bundle.main.infoDictionary?["BASE_URL"] as! String
      return URL(string: baseURLString)!
    }
  }
  
  public var path: String {
    switch self {
    case .fetchCakeShopQuickInfo(let shopId, _):
      return "/api/v1/shops/\(shopId)/simple"
      
    case .fetchCakeShopDetail(let shopId):
      return "/api/v1/shops/\(shopId)"
    
    case .fetchAdditionalInfo(let shopId):
      return "/api/v1/shops/\(shopId)/info"
      
    case .uploadCakeShop:
      return "/api/v1/shops/admin/create"
      
    case .updateCakeShopBasicInfo(let shopId, _, _, _, _, _):
      return "/api/v1/shops/\(shopId)"
      
    case .updateExternalLinks(let shopId, _, _, _, _):
      return "/api/v1/shops/\(shopId)/links"
      
    case .updateOperationDays(let shopId, _, _):
      return "/api/v1/shops/\(shopId)/operation-days"
      
    case .updateShopAddress(let shopId, _, _, _, _):
      return "/api/v1/shops/\(shopId)/address"
      
    case .fetchCakeImageDetail(let imageId):
      return "/api/v1/cakes/\(imageId)"
      
    case .uploadCakeImage(let shopId, _, _):
      return "/api/v1/cakes/\(shopId)"
      
    case .editCakeImage(let cakeImageId, _, _),
        .deleteCakeImage(let cakeImageId, _):
      return "/api/v1/cakes/\(cakeImageId)"
      
    case .requestPresignedUrl:
      return "/api/v1/aws/img"
      
    case .uploadPresignedImage:
      return "" /// Presigned URL은 전체 URL을 제공하므로 별도의 경로가 필요 없습니다.
      
    case .isOwned(let shopId, _):
      return "/api/v1/shops/\(shopId)/owner"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .fetchCakeShopQuickInfo:
      return .get
      
    case .fetchCakeShopDetail:
      return .get
      
    case .fetchAdditionalInfo:
      return .get
      
    case .uploadCakeShop:
      return .post
      
    case .updateCakeShopBasicInfo:
      return .put
      
    case .updateExternalLinks:
      return .put
      
    case .updateOperationDays:
      return .put
      
    case .updateShopAddress:
      return .put
      
    case .fetchCakeImageDetail:
      return .get
      
    case .uploadCakeImage:
        return .post
      
    case .editCakeImage:
      return .put
      
    case .deleteCakeImage:
      return .delete
      
    case .requestPresignedUrl:
      return .get
      
    case .uploadPresignedImage:
      return .put
      
    case .isOwned:
      return .get
    }
  }
  
  public var task: Moya.Task {
    switch self {
    case .fetchCakeShopQuickInfo(_, let cakeImageId):
      var params = [String: Any]()
      if let cakeImageId {
        params["cakeId"] = cakeImageId
      }
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .fetchCakeShopDetail:
      return .requestPlain
    
    case .fetchAdditionalInfo:
      return .requestPlain
      
    case .uploadCakeShop(let newCakeShopDTO):
      return .requestJSONEncodable(newCakeShopDTO)
      
    case .updateCakeShopBasicInfo(_, let thumbnailUrl, let shopName, let shopBio, let shopDescription, _):
      var params: [String: Any] = [
        "shopName": shopName
      ]
      params["thumbnailUrl"] = thumbnailUrl == nil ? "" : thumbnailUrl // TODO: - 서버에서 optional로 받도록 변경 되면 바로 아래 코드처럼 if let 으로 변경
      if let shopBio { params["shopBio"] = shopBio }
      if let shopDescription { params["shopDescription"] = shopDescription }
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
      
    case .updateExternalLinks(_, let instaUrl, let kakaoUrl, let webUrl, _):
      var params = [String: Any]()
      if let instaUrl, !instaUrl.isEmpty { params["instagram"] = instaUrl }
      if let kakaoUrl, !kakaoUrl.isEmpty { params["kakao"] = kakaoUrl }
      if let webUrl, !webUrl.isEmpty{ params["web"] = webUrl }
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
      
    case .updateOperationDays(_, let operationDays, _):
      return .requestJSONEncodable(operationDays)
      
    case .updateShopAddress(_, let address, let latitude, let longitude, _):
      let params: [String: Any] = [
        "shopAddress": address,
        "latitude": latitude,
        "longitude": longitude
      ]
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
      
    case .fetchCakeImageDetail:
      return .requestPlain
      
    case .uploadCakeImage(_, let newCakeImage, _),
        .editCakeImage(_, let newCakeImage, _):
      return .requestJSONEncodable(newCakeImage)
      
    case .deleteCakeImage:
      return .requestPlain
      
    case .requestPresignedUrl:
      return .requestPlain
      
    case .uploadPresignedImage(_, let image):
      return .requestData(image)
      
    case .isOwned:
      return .requestPlain
    }
  }
  
  public var headers: [String : String]? {
    switch self {
    case .updateCakeShopBasicInfo(_, _, _, _, _, let accessToken),
        .updateOperationDays(_, _, let accessToken),
        .uploadCakeImage(_, _, let accessToken),
        .editCakeImage(_, _, let accessToken),
        .deleteCakeImage(_, let accessToken),
        .updateShopAddress(_, _, _, _, let accessToken),
        .isOwned(_, let accessToken):
      return [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(accessToken)"
      ]
    
    case .uploadPresignedImage:
      return ["Content-Type": "image/jpeg"]
      
    default:
      return ["Content-Type": "application/json"]
    }
  }
  
  public var sampleData: Data {
    switch self {
    case .fetchCakeShopQuickInfo:
      return try! Data(contentsOf: Bundle.module.url(forResource: "CakeShopQuickInfoSampleResponse", withExtension: "json")!)
      
    case .fetchCakeShopDetail:
      return try! Data(contentsOf: Bundle.module.url(forResource: "CakeShopDetailSampleResponse", withExtension: "json")!)
      
    case .fetchAdditionalInfo:
      return try! Data(contentsOf: Bundle.module.url(forResource: "AdditionalShopInfoSampleResponse", withExtension: "json")!)
      
    default:
      return Data()
    }
  }
}
