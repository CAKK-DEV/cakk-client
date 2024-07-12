//
//  ImageLoader.swift
//  CommonUtil
//
//  Created by 이승기 on 7/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import SwiftUI

import Kingfisher

public final class ImageLoader {
  
  // MARK: - Properties
  
  public static let shared = ImageLoader()
  
  
  // MARK: - Initializers
  
  private init() {
    configureCache()
  }
  
  
  // MARK: - Public Methods
  
  public func loadImage(with url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> DownloadTask? {
    let task = KingfisherManager.shared.retrieveImage(with: url) { result in
      switch result {
      case .success(let value):
        let downSampledImage = value.image.kf.resize(to: .init(width: 512, height: 512), for: .aspectFit)
        completion(.success(downSampledImage))
      case .failure(let error):
        completion(.failure(error))
      }
    }
    return task
  }
  
  public func cancelLoad(_ task: DownloadTask?) {
    task?.cancel()
  }
  
  public func clearCache() {
    KingfisherManager.shared.cache.clearMemoryCache()
    KingfisherManager.shared.cache.clearDiskCache()
  }
  
  
  // MARK: - Private Methods
  
  private func configureCache() {
    /// 메모리 캐시 크기를 300MB로 제한
    KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 300 * 1024 * 1024
    
    /// 디스크 캐시 크기를 1GB로 제한
    KingfisherManager.shared.cache.diskStorage.config.sizeLimit = 1024 * 1024 * 1024
  }
}
