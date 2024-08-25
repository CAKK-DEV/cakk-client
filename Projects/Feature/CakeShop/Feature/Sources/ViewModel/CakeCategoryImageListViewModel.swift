//
//  CakeCategoryImageListViewModel.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Moya

import Combine
import SwiftUI

import CommonDomain
import DomainCakeShop
import DomainSearch

public final class CakeCategoryImageListViewModel: ObservableObject {
  
  // MARK: - Properties
  
  var category: CakeCategory
  let useCase: CakeImagesByCategoryUseCase
  
  private var cancellables = Set<AnyCancellable>()
  private var currentFetchCancellable: AnyCancellable?
  private var currentFetchMoreCancellable: AnyCancellable?
  @Published private(set) var cakeImages: [CakeImage] = []
  
  enum ImageFetchingState {
    case loading
    case idle
    case success
    case failure
    case failureLoadMore
  }
  @Published private(set) var imageFetchingState: ImageFetchingState = .idle
  
  
  // MARK: - Initializers
  
  public init(
    category: CakeCategory,
    useCase: CakeImagesByCategoryUseCase
  ) {
    self.category = category
    self.useCase = useCase
    fetchCakeImages()
  }
  
  
  // MARK: - Public Methods
  
  public func fetchCakeImages() {
    imageFetchingState = .loading
    cakeImages.removeAll()
    
    // 기존에 진행중이던 작업 취소
    currentFetchCancellable?.cancel()
    currentFetchMoreCancellable?.cancel()
    
    currentFetchCancellable = useCase.execute(category: category, count: 10, lastCakeId: nil)
      .subscribe(on: DispatchQueue.global(qos: .userInitiated))
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case let .failure(error) = completion {
          self?.imageFetchingState = .failure
          print(error.localizedDescription)
        } else {
          self?.imageFetchingState = .success
        }
      } receiveValue: { [weak self] value in
        guard let self else { return }
        self.cakeImages = value
      }
    currentFetchCancellable?.store(in: &cancellables)
  }
  
  public func fetchMoreCakeImages() {
    imageFetchingState = .loading
    
    // 기존에 진행중이던 작업 취소
    currentFetchMoreCancellable?.cancel()
    
    if let lastCakeId = cakeImages.last?.id {
      currentFetchMoreCancellable = useCase.execute(category: category, count: 10, lastCakeId: lastCakeId)
        .subscribe(on: DispatchQueue.global(qos: .userInitiated))
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
          if case let .failure(error) = completion {
            self?.imageFetchingState = .failureLoadMore
            print(error.localizedDescription)
          } else {
            self?.imageFetchingState = .success
          }
        } receiveValue: { [weak self] value in
          guard let self else { return }
          self.cakeImages.append(contentsOf: value)
        }
      currentFetchMoreCancellable?.store(in: &cancellables)
    }
  }
}


// MARK: - Preview

import DIContainer
import PreviewSupportSearch

#Preview("Success") {
  let diContainer = DIContainer.shared.container
  diContainer.register(CakeCategoryImageListViewModel.self) { resolver in
    let useCase = MockCakeImagesByCategoryUseCase(scenario: .success)
    return CakeCategoryImageListViewModel(category: .threeDimensional,
                                          useCase: useCase)
  }
  return CakeCategoryImageListView(category: .character)
}

#Preview("Failure") {
  let diContainer = DIContainer.shared.container
  diContainer.register(CakeCategoryImageListViewModel.self) { resolver in
    let useCase = MockCakeImagesByCategoryUseCase(scenario: .failure)
    return CakeCategoryImageListViewModel(category: .threeDimensional,
                                          useCase: useCase)
  }
  return CakeCategoryImageListView(category: .character)
}
