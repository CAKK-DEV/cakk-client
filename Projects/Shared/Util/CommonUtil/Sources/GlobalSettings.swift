//
//  GlobalSettings.swift
//  CommonUtil
//
//  Created by 이승기 on 7/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public enum GlobalSettings {
  @UserDefault(key: "CAKE_SHOP_LIKE_STATE", defaultValue: false)
  public static var didChangeCakeShopLikeState: Bool
  
  @UserDefault(key: "CAKE_IMAGE_LIKE_STATE", defaultValue: false)
  public static var didChangeCakeImageLikeState: Bool
}
