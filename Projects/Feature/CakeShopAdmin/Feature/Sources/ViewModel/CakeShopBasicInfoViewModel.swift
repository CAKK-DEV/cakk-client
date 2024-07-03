//
//  CakeShopBasicInfoViewModel.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//
//
//import UIKit
//import Combine
//
//import DomainCakeShop
//
//public final class CakeShopBasicInfoViewModel: ObservableObject {
//  
//  // MARK: - Properties
//  
//  @Published private(set) var originalProfileImageUrl: String
//  @Published var shopName: String = ""
//  @Published var shopBio: String = ""
//  @Published var shopDescription: String = ""
//  @Published var newProfileImage: UIImage?
//  
//  private let shopId: Int
//  private let editShopBasicInfoUseCase: EditShopBasicInfoUseCase
//  @Published private(set) var updatingState: BasicInfoUpdatingState = .idle
//  enum BasicInfoUpdatingState {
//    case idle
//    case loading
//    case failure
//    case success
//  }
//  
//  private var cancellables = Set<AnyCancellable>()
//  
//  
//  // MARK: - Initializers
//  
//  public init(
//    shopId: Int,
//    originalProfileImageUrl: String,
//    editShopBasicInfoUseCase: EditShopBasicInfoUseCase
//  ) {
//    self.shopId = shopId
//    self.originalProfileImageUrl = originalProfileImageUrl
//    self.editShopBasicInfoUseCase = editShopBasicInfoUseCase
//  }
//  
//  
//  // MARK: - Public Methods
//  
//  public func updateInfo() {
//    editShopBasicInfoUseCase.execute(cakeShopId: shopId,
//                                     newCakeShopBasicInfo: <#T##NewCakeShopBasicInfo#>)
//    .subscribe(on: DispatchQueue.global())
//    .receive(on: DispatchQueue.main)
//    .sink { [weak self] completion in
//      if case .failure(let error) = completion {
//        self?.updatingState = .failure
//        print(error.localizedDescription)
//      } else {
//        self?.updatingState = .success
//      }
//    } receiveValue: { _ in }
//    .store(in: &cancellables)
//
//  }
//}CakeShopBasicInfoViewModel
