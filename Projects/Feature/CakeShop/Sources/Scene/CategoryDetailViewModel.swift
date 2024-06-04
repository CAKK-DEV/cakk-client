//
//  CategoryDetailViewModel.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop
import Moya

import Combine

import Combine
import SwiftUI

import DIContainer

public final class CategoryDetailViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private let diContainer: DIContainerProtocol
  
  @Published var category: CakeCategory {
    didSet {
      fetchCakeImages()
    }
  }
  let useCase: CakeImagesByCategoryUseCase
  
  private var cancellables = Set<AnyCancellable>()
  private var currentFetchCancellable: AnyCancellable?
  private var currentFetchMoreCancellable: AnyCancellable?
  @Published private(set) var cakeImages: [CakeImage] = []
  
  enum ImageFetchingState {
    case loading
    case idle
    case failure
    case failureLoadMore
  }
  @Published private(set) var imageFetchingState: ImageFetchingState = .idle
  
  
  // MARK: - Initializers
  
  public init(initialCategory: CakeCategory, diContainer: DIContainerProtocol) {
    _category = .init(initialValue: initialCategory)
    self.diContainer = diContainer
    self.useCase = diContainer.resolve(CakeImagesByCategoryUseCase.self)!
    
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
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case let .failure(error) = completion {
          self?.imageFetchingState = .failure
          print(error)
        } else {
          self?.imageFetchingState = .idle
        }
      } receiveValue: { [weak self] value in
        self?.cakeImages = value
      }
    currentFetchCancellable?.store(in: &cancellables)
  }
  
  public func fetchMoreCakeImages() {
    imageFetchingState = .loading
    
    // 기존에 진행중이던 작업 취소
    currentFetchMoreCancellable?.cancel()
    
    if let lastCakeId = cakeImages.last?.id {
      currentFetchMoreCancellable = useCase.execute(category: category, count: 10, lastCakeId: lastCakeId)
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
          if case let .failure(error) = completion {
            self?.imageFetchingState = .failureLoadMore
            print(error)
          } else {
            self?.imageFetchingState = .idle
          }
        } receiveValue: { [weak self] value in
          self?.cakeImages.append(contentsOf: value)
        }
      currentFetchMoreCancellable?.store(in: &cancellables)
    }
  }
}
