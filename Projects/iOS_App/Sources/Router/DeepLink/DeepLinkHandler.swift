//
//  DeepLinkHandler.swift
//  CAKK
//
//  Created by 이승기 on 8/28/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

import CommonUtil
import DIContainer
import LinkNavigator

class DeepLinkHandler {
  func handle(deepLink: DeepLink) {
    switch deepLink.host {
    case "kakaolink":
      if let shopId = deepLink.queryItems.first?.value {
        openShop(with: shopId)
      }
      
    case "shopid":
      if let shopId = deepLink.queryItems.first?.value {
        openShop(with: shopId)
      }
      
    default:
      print("Unhandled DeepLink host: \(deepLink.host)")
    }
  }
  
  private func openShop(with shopId: String) {
    guard let shopId = Int(shopId) else { return }
    
    let container = DIContainer.shared.container
    let navigator = container.resolve(LinkNavigatorType.self)
    
    let items = RouteHelper.ShopDetail.items(shopId: shopId)
    navigator?.next(paths: [RouteHelper.ShopDetail.path], items: items, isAnimated: true)
  }
}
