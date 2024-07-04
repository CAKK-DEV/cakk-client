//
//  NewCakeImageViewModel.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import CommonDomain
import DomainCakeShop

public final class NewCakeImageViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private(set) var shopId: Int
  @Published var cakeImage: UIImage?
  private let uploadCakeImageUseCase: UploadCakeImageUseCase
  
  @Published private(set) var categories: [CakeCategory] = []
  
  @Published var tagString = ""
  @Published private(set) var tags: [String] = []
  
  @Published private(set) var imageUploadingState: ImageUploadingState = .idle
  enum ImageUploadingState {
    case idle
    case loading
    case failure
    case emptyCategory
    case emptyImage
    case success
  }
  
  private var cancenllables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    shopId: Int,
    uploadCakeImageUseCase: UploadCakeImageUseCase
  ) {
    self.shopId = shopId
    self.uploadCakeImageUseCase = uploadCakeImageUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func uploadCakeImage() {
    guard let cakeImage else {
      imageUploadingState = .emptyImage
      return
    }
    
    if categories.isEmpty {
      imageUploadingState = .emptyCategory
      return
    }
    
    imageUploadingState = .loading
    
    uploadCakeImageUseCase.execute(cakeShopId: shopId, image: cakeImage, categories: categories, tags: tags)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.imageUploadingState = .failure
          print(error.localizedDescription)
        } else {
          self?.imageUploadingState = .success
        }
      } receiveValue: { _ in }
      .store(in: &cancenllables)
  }
  
  public func addNewTag(tagString: String) {
    if tagString.isEmpty { return }
    
    let tagString = tagString.trimmingCharacters(in: .whitespacesAndNewlines)
    if !tags.contains(tagString) {
      tags.append(tagString)
    }
    
    self.tagString = ""
  }
  
  public func deleteTag(tagString: String) {
    let tagString = tagString.trimmingCharacters(in: .whitespacesAndNewlines)
    if let index = tags.firstIndex(of: tagString) {
      tags.remove(at: index)
    }
  }
  
  public func toggleCategory(_ category: CakeCategory) {
    if categories.contains(category) {
      if let index = categories.firstIndex(of: category) {
        categories.remove(at: index)
      }
    } else {
      categories.append(category)
    }
  }
  
  public func updateCake(image: UIImage) {
    self.cakeImage = image
  }
}
