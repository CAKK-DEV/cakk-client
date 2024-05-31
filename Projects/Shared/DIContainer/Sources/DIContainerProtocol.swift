//
//  Container.swift
//  DIContainer
//
//  Created by 이승기 on 5/29/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public protocol DIContainerProtocol {
  func resolve<Service>(_ serviceType: Service.Type) -> Service?
  func register<Service>(_ serviceType: Service.Type, factory: @escaping (DIContainerProtocol) -> Service)
}
