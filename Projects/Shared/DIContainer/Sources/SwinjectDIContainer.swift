//
//  SwinjectDIContainer.swift
//  DIContainer
//
//  Created by 이승기 on 5/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

import Swinject

public class SwinjectDIContainer: DIContainerProtocol {
  private let container: Container
  
  public init() {
    container = Container()
  }
  
  public func resolve<Service>(_ serviceType: Service.Type) -> Service? {
    return container.resolve(serviceType)
  }
  
  public func register<Service>(_ serviceType: Service.Type, factory: @escaping (DIContainerProtocol) -> Service) {
    container.register(serviceType) { [weak self] _ in
      guard let self else { fatalError("DIContainer deallocated") }
      return factory(self)
    }
  }
}
