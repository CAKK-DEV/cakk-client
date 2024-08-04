//
//  DIContainer.swift
//  DIContainer
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Swinject

public final class DIContainer {

  // MARK: - Properties
  
  public static var shared = DIContainer()
  public var container = Container()
  
  
  // MARK: - Initializers
  
  private init() { }
}
