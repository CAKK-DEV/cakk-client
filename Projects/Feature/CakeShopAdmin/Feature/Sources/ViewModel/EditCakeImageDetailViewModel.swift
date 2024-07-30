//
//  EditCakeImageDetailViewModel.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import CommonDomain
import DomainCakeShop

public final class EditCakeImageDetailViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private let cakeImageId: Int
  @Published var tagString = ""
  
  @Published private(set) var categories: [CakeCategory] = []
  @Published private(set) var tags: [String] = []
  
  private let cakeImageDetailUseCase: CakeImageDetailUseCase
  @Published private(set) var cakeImageDetail: CakeImageDetail?
  @Published private(set) var cakeImageDetailFetchingState: CakeImageDetailFetchingState = .idle
  enum CakeImageDetailFetchingState {
    case idle
    case loading
    case success
    case failure
  }
  
  private let editCakeImageUseCase: EditCakeImageUseCase
  @Published private(set) var cakeImageUpdatingState: CakeImageUpdatingState = .idle
  enum CakeImageUpdatingState {
    case idle
    case loading
    case success
    case failure
  }
  
  private let deleteCakeImageUseCase: DeleteCakeImageUseCase
  @Published private(set) var cakeImageDeletingState: CakeImageDeletingState = .idle
  enum CakeImageDeletingState {
    case idle
    case loading
    case success
    case failure
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(
    cakeImageId: Int,
    cakeImageDetailUseCase: CakeImageDetailUseCase,
    editCakeImageUseCase: EditCakeImageUseCase,
    deleteCakeImageUseCase: DeleteCakeImageUseCase
  ) {
    self.cakeImageId = cakeImageId
    self.cakeImageDetailUseCase = cakeImageDetailUseCase
    self.editCakeImageUseCase = editCakeImageUseCase
    self.deleteCakeImageUseCase = deleteCakeImageUseCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchImageDetail() {
    cakeImageDetailUseCase.execute(cakeImageId: cakeImageId)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.cakeImageDetailFetchingState = .failure
          print(error.localizedDescription)
        } else {
          self?.cakeImageDetailFetchingState = .success
        }
      } receiveValue: { [weak self] cakeImageDetail in
        self?.cakeImageDetail = cakeImageDetail
        self?.categories = cakeImageDetail.categories
        self?.tags = cakeImageDetail.tags
      }
      .store(in: &cancellables)
  }
  
  public func updateCakeImage() {
    guard let cakeImageDetail else { return }
    
    cakeImageUpdatingState = .loading
    
    editCakeImageUseCase.execute(cakeImageId: cakeImageId,
                                 imageUrl: cakeImageDetail.imageUrl,
                                 categories: categories,
                                 tags: tags)
    .sink { [weak self] completion in
      if case .failure(let error) = completion {
        self?.cakeImageUpdatingState = .failure
        print(error.localizedDescription)
      } else {
        self?.cakeImageUpdatingState = .success
      }
    } receiveValue: { _ in }
    .store(in: &cancellables)
  }
  
  public func deleteCakeImage() {
    cakeImageDeletingState = .loading
    
    deleteCakeImageUseCase.execute(cakeImageId: cakeImageId)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.cakeImageDeletingState = .failure
          print(error.localizedDescription)
        } else {
          self?.cakeImageDeletingState = .success
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
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
  
  public func hasChanges() -> Bool {
    guard let cakeImageDetail else { return false }
    
    if cakeImageDetail.categories != categories ||
        cakeImageDetail.tags != tags {
      return true
    }
    
    return false
  }
}
