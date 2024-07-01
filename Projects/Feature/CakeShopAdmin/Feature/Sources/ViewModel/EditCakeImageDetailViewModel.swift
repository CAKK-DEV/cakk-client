//
//  EditCakeImageDetailViewModel.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DomainCakeShop

public final class EditCakeImageDetailViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private let cakeImageId: Int
  @Published var tagString = ""
  
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
        } else {
          self?.cakeImageDetailFetchingState = .success
        }
      } receiveValue: { [weak self] cakeImageDetail in
        self?.cakeImageDetail = cakeImageDetail
      }
      .store(in: &cancellables)
  }
  
  public func updateCakeImage() {
    
  }
  
  public func deleteCakeImage() {
    
  }
  
  public func addNewTag(tagString: String) {
    if cakeImageDetail == nil { return }
    if tagString.isEmpty { return }
    
    let tagString = tagString.trimmingCharacters(in: .whitespacesAndNewlines)
    if !cakeImageDetail!.tags.contains(tagString) {
      cakeImageDetail!.tags.append(tagString)
    }
    
    self.tagString = ""
  }
  
  public func deleteTag(tagString: String) {
    let tagString = tagString.trimmingCharacters(in: .whitespacesAndNewlines)
    if let index = cakeImageDetail?.tags.firstIndex(of: tagString) {
      cakeImageDetail?.tags.remove(at: index)
    }
  }
  
  public func toggleCategory(_ category: CakeCategory) {
    if cakeImageDetail == nil { return }
    
    if cakeImageDetail!.categories.contains(category) {
      if let index = cakeImageDetail!.categories.firstIndex(of: category) {
        cakeImageDetail!.categories.remove(at: index)
      }
    } else {
      cakeImageDetail?.categories.append(category)
    }
  }
}
