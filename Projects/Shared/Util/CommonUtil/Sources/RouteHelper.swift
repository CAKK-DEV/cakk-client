//
//  RouteHelper.swift
//  CommonUtil
//
//  Created by 이승기 on 8/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

/**
 `RouteHelper`는 `LinkNavigator`를 사용할 때 경로(`RoutePath`)와 `items`의 인자값을 안전하게 관리하고,
 매직 넘버(magic number)나 하드코딩된 문자열을 방지하도록 돕는 헬퍼 객체입니다.
 
 이 객체를 통해 경로 및 관련 데이터를 구조화하여, 잘못된 값 사용으로 인한 오류를 줄이고
 코드의 가독성과 유지 보수성을 높일 수 있습니다.
 
 각 경로와 항목 키는 명확하게 정의되어 있어, 새로운 개발자가 쉽게 이해하고 사용할 수 있습니다.
 
 자세한 설명은
 */
public struct RouteHelper {
  
  public struct TabRoot {
    public static var path = "tab_root"
  }
  
  // MARK: - Feature CakeShop
  
  public struct ShopDetail {
    public static var path = "shop_detail"
    public static func items(shopId: Int) -> [String: String] {
      return ["shopId": shopId.description]
    }
  }
  
  public struct ShopQuickInfo {
    public static var path = "shop_quick_info"
    public static func items(imageId: Int, cakeImageUrl: String, shopId: Int) -> [String: String] {
      return [
        "imageId": imageId.description,
        "cakeImageUrl": cakeImageUrl,
        "shopId": shopId.description
      ]
    }
  }
  
  public struct Category {
    public static var path = "category"
    /**
     - Parameters:
       - category: `CakeCategory`의 rawValue
     */
    public static func items(category: String) -> [String: String] {
      return [
        "category": category.description
      ]
    }
  }
  
  public struct Home {
    public static var path = "home"
    public static func items() -> [String: String] {
      return [:]
    }
  }
  
  public struct ImageZoomable {
    public static var path = "image_zoomable"
    public static func items(imageUrl: String) -> [String: String] {
      return [
        "imageUrl": imageUrl
      ]
    }
  }
  
  // MARK: - Feature CakeShopAdmin
  
  public struct EditShopAddress {
    public static var path = "edit_shop_address"
    public static func items(shopId: Int) -> [String: String] {
      return [
        "shopId": shopId.description
      ]
    }
  }
  
  public struct EditShopImageDetail {
    public static var path = "edit_shop_image_detail"
    public static func items(cakeImageId: Int) -> [String: String] {
      return [
        "cakeImageId": cakeImageId.description
      ]
    }
  }
  
  public struct EditShopBasicInfo {
    public static var path = "edit_shop_basic_info"
    public static func items(shopId: Int) -> [String: String] {
      return [
        "shopId": shopId.description
      ]
    }
  }
  
  public struct EditShopImage {
    public static var path = "edit_shop_image"
    public static func items(shopId: Int) -> [String: String] {
      return [
        "shopId": shopId.description
      ]
    }
  }
  
  public struct EditExternalLink {
    public static var path = "edit_shop_external_link"
    public static func items(shopId: Int) -> [String: String] {
      return [
        "shopId": shopId.description
      ]
    }
  }
  
  public struct EditShopWorkingDay {
    public static var path = "edit_shop_working_day"
    public static func items(shopId: Int) -> [String: String] {
      return [
        "shopId": shopId.description
      ]
    }
  }
  
  public struct NewCakeImage {
    public static var path = "new_cake_image"
    public static func items(shopId: Int) -> [String: String] {
      return [
        "shopId": shopId.description
      ]
    }
  }
  
  
  // MARK: - Feature Onboarding
  
  public struct Onboarding {
    public static var path = "onboarding"
    public static func items() -> [String: String] {
      return [:]
    }
  }
  
  
  // MARK: - Feature Search
  
  public struct Map {
    public static var path = "map"
    public static func items() -> [String: String] {
      return [:]
    }
  }
  
  public struct Search {
    public static var path = "search"
    public static func items() -> [String: String] {
      return [:]
    }
  }
  
  
  // MARK: - Feature User
  
  public struct BusinessCertification {
    public static var path = "business_certification"
    public static func items(shopId: Int) -> [String: String] {
      return [
        "shopId": shopId.description
      ]
    }
  }
  
  public struct EditProfile {
    public static var path = "edit_profile"
    public static func items() -> [String: String] {
      return [:]
    }
  }
  
  public struct Login {
    public static var path = "login"
    public static func items() -> [String: String] {
      return [:]
    }
  }
  
  public struct Profile {
    public static var path = "profile"
    public static func items() -> [String: String] {
      return [:]
    }
  }
  
  public struct SearchMyShop {
    public static var path = "search_my_shop"
    public static func items() -> [String: String] {
      return [:]
    }
  }
  
  public struct SignUp {
    public static var path = "sign_up"
    /**
     - Parameters
      - loginType: LoginProvider의 rawValue
     */
    public static func items(loginType: Int) -> [String: String] {
      return [
        "loginType": loginType.description
      ]
    }
  }
}
