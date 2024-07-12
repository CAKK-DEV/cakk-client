//
//  CakeImageGridItemViewModel.swift
//  DesignSystem
//
//  Created by 이승기 on 7/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import CommonUtil
import Kingfisher

class CakeImageGridItemViewModel: ObservableObject {
  
  // MARK: - Properties
  
  @Published var image: UIImage?
  private var token: UUID?
  private let imageLoader = ImageLoader.shared
  
  private var task: DownloadTask?
  
  
  // MARK: - Public Methods
  
  func loadImage(from urlString: String) {
    guard let url = URL(string: urlString) else { return }
    
    self.task = imageLoader.loadImage(with: url, completion: { result in
      if let image = try? result.get() {
        DispatchQueue.main.async {
          self.image = image
        }
      }
    })
  }
  
  func cancelLoad() {
    if let task {
      imageLoader.cancelLoad(task)
    }
  }
  
  func cleanImage() {
    image = nil
  }
}
