//
//  ImageUploaderAssembly.swift
//  CAKK
//
//  Created by 이승기 on 8/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Swinject

import Moya
import MoyaUtil

import NetworkImage

final class ImageUploaderAssembly: Assembly {
  public func assemble(container: Container) {
    container.register(MoyaProvider<ImageUploadAPI>.self) { _ in
      MoyaProvider<ImageUploadAPI>(plugins: [MoyaLoggingPlugin()])
    }
    
    container.register(ImageUploadRepository.self) { resolver in
      let provider = resolver.resolve(MoyaProvider<ImageUploadAPI>.self)!
      return ImageUploadRepository(provider: provider)
    }
  }
}
