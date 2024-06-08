//
//  CakeShopQuickInfoView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/7/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem
import SwiftUIUtil

import DomainCakeShop

import Swinject

struct CakeShopQuickInfoView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: CakeShopQuickInfoViewModel
  
  @Environment(\.dismiss) private var dismiss
  @State private var currentDetent: PresentationDetent = .fraction(0.7)
  
  
  // MARK: - Initializers
  
  init(diContainer: Container) {
    let viewModel = diContainer.resolve(CakeShopQuickInfoViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  

  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 28) {
      VStack(spacing: 20) {
        if let shopName = viewModel.shopInfo?.shopName {
          Text(shopName)
            .font(.pretendard(size: 24, weight: .bold))
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
            .lineLimit(1)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 68)
        } else {
          RoundedRectangle(cornerRadius: 10)
            .fill(DesignSystemAsset.gray20.swiftUIColor)
            .frame(width: 120, height: 24)
        }
        
        if let shopBio = viewModel.shopInfo?.shopBio {
          Text(shopBio)
            .font(.pretendard(size: 15, weight: .medium))
            .foregroundStyle(DesignSystemAsset.gray40.swiftUIColor)
            .lineLimit(3)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
        } else {
          VStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 4)
              .fill(DesignSystemAsset.gray20.swiftUIColor)
              .frame(width: 200, height: 12)
            
            RoundedRectangle(cornerRadius: 4)
              .fill(DesignSystemAsset.gray20.swiftUIColor)
              .frame(width: 140, height: 12)
          }
        }
      }
      .padding(.top, 36)
      
      imageView(imageUrl: viewModel.cakeImageUrl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        .onTapGesture {
          currentDetent = .custom(CustomDetent.self)
        }
      
      HStack(spacing: 8) {
        Button {
          // heart action
        } label: {
          RoundedRectangle(cornerRadius: 20)
            .stroke(DesignSystemAsset.gray30.swiftUIColor, lineWidth: 1)
            .frame(width: 76, height: 64)
            .overlay {
              Image(systemName: "heart")
                .font(.system(size: 24))
                .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
            }
        }
        
        CKButtonLargeStroked(title: "방문", fixedSize: 148)
      }
      .padding(.bottom, 24)
    }
    .animation(.snappy, value: viewModel.dataFetchingState)
    .overlay {
      VStack(spacing: 0) {
        HStack(spacing: 0) {
          Spacer()
          
          Button {
            dismiss()
          } label: {
            Circle()
              .fill(DesignSystemAsset.gray10.swiftUIColor)
              .size(36)
              .overlay {
                Image(systemName: "xmark")
                  .font(.system(size: 15, weight: .semibold))
                  .foregroundStyle(DesignSystemAsset.gray40.swiftUIColor)
              }
              .padding(16)
          }
        }
        
        Spacer()
      }
    }
    .presentationDetents([.fraction(0.7), .custom(CustomDetent.self)], selection: $currentDetent)
    .presentationCornerRadius(32)
    .presentationDragIndicator(.hidden)
    .onAppear {
      viewModel.requestCakeShopQuickInfo()
    }
  }
  
  private func imageView(imageUrl: String) -> some View {
    AsyncImage(
      url: URL(string: imageUrl),
      transaction: Transaction(animation: .bouncy)
    ) { phase in
      switch phase {
      case .empty:
        // Placeholder
        RoundedRectangle(cornerRadius: 22)
          .fill(.clear)
          .frame(height: 100)
          .overlay {
            ProgressView()
          }
      case .success(let image):
        // Image loaded with animation
        image
          .resizable()
          .scaledToFit()
          .clipShape(RoundedRectangle(cornerRadius: 22))
          .shadow(color: .black.opacity(0.1), radius: 20, y: 4)
          .transition(.opacity)
      case .failure:
        // Error handling
        RoundedRectangle(cornerRadius: 22)
          .fill(DesignSystemAsset.gray10.swiftUIColor)
          .aspectRatio(3/4, contentMode: .fit)
          .overlay(
            Text("Failed to load image")
              .foregroundColor(.white)
          )
      @unknown default:
        // Default case
        RoundedRectangle(cornerRadius: 22)
          .fill(DesignSystemAsset.gray10.swiftUIColor)
          .aspectRatio(3/4, contentMode: .fit)
      }
    }
  }
}


// MARK: - Preview
import PreviewSupportCakeShop

#Preview {
  let diContainer = Container()
  diContainer.register(CakeShopQuickInfoViewModel.self) { _ in
    let useCase = MockCakeShopQuickInfoUseCase(delay: 2)
    return CakeShopQuickInfoViewModel(shopId: 0,
                                      cakeImageUrl: "https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?q=80&w=2487&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                      useCase: useCase)
  }
  return CakeShopQuickInfoView(diContainer: diContainer)
}
