//
//  TrendingCakeImagesViewModel.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/17/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Combine

import CommonDomain
import DomainSearch

public final class TrendingCakeImagesViewModel: ObservableObject {
 
  // MARK: - Properties
  
  @Published private(set) var cakeImages: [CakeImage] = []
  private let trendingCakeImagesUseCase: TrendingCakeImagesUseCase
  @Published private(set) var imageFetchingState: ImageFetchingState = .idle
  enum ImageFetchingState {
    case idle
    case loading
    case success
    case failure
    case loadMoreFailure
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(useCase: TrendingCakeImagesUseCase) {
    self.trendingCakeImagesUseCase = useCase
  }
  
  
  // MARK: - Public Methods
  
  public func fetchCakeImages() {
    imageFetchingState = .loading
    
    trendingCakeImagesUseCase
      .execute(lastImageId: nil, pageSize: 10)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure = completion {
          self?.imageFetchingState = .failure
        } else {
          self?.imageFetchingState = .success
        }
      } receiveValue: { [weak self] cakeImages in
        self?.cakeImages = cakeImages
      }
      .store(in: &cancellables)
  }
  
  public func fetchMoreCakeImages() {
    imageFetchingState = .loading
    
    if let lastCakeId = cakeImages.last?.id {
      trendingCakeImagesUseCase
        .execute(lastImageId: lastCakeId, pageSize: 10)
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
          if case let .failure(error) = completion {
            self?.imageFetchingState = .loadMoreFailure
            print(error.localizedDescription)
          } else {
            self?.imageFetchingState = .success
          }
        } receiveValue: { [weak self] value in
          self?.cakeImages.append(contentsOf: value)
        }
        .store(in: &cancellables)
    }
  }
}
