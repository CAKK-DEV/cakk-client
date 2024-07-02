//
//  EditCakeImageCoordinator.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 7/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DomainCakeShop

import DIContainer
import Router

// MARK: - Destination

enum EditCakeShopDestination: Hashable {
  case editCakeImageDetail(imageId: Int)
  case newCakeImage(shopId: Int)
}


public struct EditCakeImagesCoordinator: View {
  
  // MARK: - Properties
  
  private let diContainer = DIContainer.shared.container
  @EnvironmentObject private var router: Router
  
  
  // MARK: - Initializers
  
  public init()  { }
  
  
  // MARK: - Views
  
  public var body: some View {
    EditCakeShopImagesView()
      .navigationDestination(for: EditCakeShopDestination.self) { destination in
        switch destination {
        case .editCakeImageDetail(let imageId):
          let _ = diContainer.register(EditCakeImageDetailViewModel.self) { resolver in
            let cakeImageDetailUseCase = resolver.resolve(CakeImageDetailUseCase.self)!
            let editCakeImageUseCase = resolver.resolve(EditCakeImageUseCase.self)!
            let deleteCakeImageUseCase = resolver.resolve(DeleteCakeImageUseCase.self)!
            return EditCakeImageDetailViewModel(cakeImageId: imageId,
                                                cakeImageDetailUseCase: cakeImageDetailUseCase,
                                                editCakeImageUseCase: editCakeImageUseCase,
                                                deleteCakeImageUseCase: deleteCakeImageUseCase)
          }
          EditCakeImageDetailView()
            .environmentObject(router)
          
        case .newCakeImage(let shopId):
          let _ = diContainer.register(NewCakeImageViewModel.self) { resolver in
            let uploadCakeImageUseCase = resolver.resolve(UploadCakeImageUseCase.self)!
            return NewCakeImageViewModel(shopId: shopId, uploadCakeImageUseCase: uploadCakeImageUseCase)
          }
          NewCakeImageView()
            .environmentObject(router)
        }
      }
  }
}


// MARK: - Preview

#Preview {
  EditCakeImagesCoordinator()
}
