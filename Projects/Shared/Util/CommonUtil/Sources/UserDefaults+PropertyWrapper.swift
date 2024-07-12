//
//  UserDefaults+PropertyWrapper.swift
//  CommonUtil
//
//  Created by 이승기 on 7/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefault<T> {
  let key: String
  let defaultValue: T
  
  public var wrappedValue: T {
    get {
      UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
}
