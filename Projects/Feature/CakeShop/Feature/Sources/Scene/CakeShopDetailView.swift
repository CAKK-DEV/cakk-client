//
//  CakeShopDetailView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil
import DesignSystem

import DIContainer
import Router

import DomainCakeShop

public struct CakeShopDetailView: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  @StateObject var viewModel: CakeShopDetailViewModel
  
  @State private var selectedDetailSection = CakeShopContentsSection.DetailSection.images
  
  
  // MARK: - Initializers
  
  public init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(CakeShopDetailViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    ZStack {
      VStack(spacing: 0) {
        NavigationBar(leadingContent: {
          Button {
            router.navigateBack()
          } label: {
            Image(systemName: "arrow.left")
              .font(.system(size: 20))
              .foregroundColor(DesignSystemAsset.black.swiftUIColor)
          }
        })
        
        if let cakeShopDetail = viewModel.cakeShopDetail {
          ScrollView {
            VStack(spacing: 24) {
              headerView(cakeShopDetail: cakeShopDetail)
                .padding(.horizontal, 24)
                .padding(.top, 24)
              
              CakeShopContentsSection(selectedSection: $selectedDetailSection)
                .environmentObject(viewModel)
            }
            .padding(.bottom, 100)
          }
        } else {
          Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
              ProgressView()
            }
        }
      }
      
      VStack {
        Spacer()
        
        HStack {
          Button {
            // heart action
          } label: {
            RoundedRectangle(cornerRadius: 20)
              .stroke(DesignSystemAsset.gray30.swiftUIColor, lineWidth: 1)
              .background(Color.white.clipShape(RoundedRectangle(cornerRadius: 20)))
              .frame(width: 76, height: 64)
              .overlay {
                Image(systemName: "heart")
                  .font(.system(size: 24))
                  .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
              }
          }
          .modifier(BouncyPressEffect())
          
          CKButtonLarge(title: "주문하기", fixedSize: .infinity) {
            withAnimation(.snappy) {
              selectedDetailSection = .order
            }
          }
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 16)
      }
    }
    .onFirstAppear {
      viewModel.fetchCakeShopDetail()
    }
    .onChange(of: viewModel.cakeShopDetailFetchingState) { state in
      switch state {
      case .failure(let error):
        LoadingManager.shared.stopLoading()
        
        if error == .noExists {
          DialogManager.shared.showDialog(
            title: "존재하지 않는 케이크샵",
            message: "존재하지 않는 케이크샵이에요.",
            primaryButtonTitle: "확인",
            primaryButtonAction: .custom({
              router.navigateBack()
            }))
        } else {
          DialogManager.shared.showDialog(.unknownError(completion: {
            router.navigateBack()
          }))
        }
      default:
        break
      }
    }
  }
  
  private func headerView(cakeShopDetail: CakeShopDetail) -> some View {
    VStack(spacing: 28) {
      VStack(alignment: .leading, spacing: 24) {
        HStack(alignment: .top, spacing: 20) {
          AsyncImage(url: URL(string: cakeShopDetail.thumbnailImageUrl ?? "")) { image in
            image
              .resizable()
              .scaledToFill()
              .frame(width: 92, height: 92)
              .overlay {
                Circle()
                  .stroke(DesignSystemAsset.gray10.swiftUIColor, lineWidth: 0.5)
              }
              .clipShape(Circle())
          } placeholder: {
            Circle()
              .fill(DesignSystemAsset.gray10.swiftUIColor)
              .frame(width: 92, height: 92)
          }
          
          VStack(spacing: 12) {
            VStack(spacing: 4) {
              Text(cakeShopDetail.shopName)
                .font(.pretendard(size: 20, weight: .bold))
                .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
              
              Text(cakeShopDetail.shopBio)
                .font(.pretendard(size: 13, weight: .regular))
                .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            WorkingDayInfoView(workingDays: cakeShopDetail.workingDays)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        ExternalShopLinksView(externalShopLinks: cakeShopDetail.externalShopLinks,
                              emptyLinkButtonAction: {
          DialogManager.shared.showDialog(
            title: "외부링크 등록",
            message: "외부링크는 케이크샵 사장님만 등록 가능해요.\n혹시 \"\(cakeShopDetail.shopName)\"(이)가 내 케이크샵이라면 사장님 인증을 완료하고 외부 링크를 등록해보세요!",
            primaryButtonTitle: "사장님 인증",
            primaryButtonAction: .custom({
              // navigate to 사장님 인증
            }), secondaryButtonTitle: "취소",
            secondaryButtonAction: .cancel)
        })
      }
      
      VStack(spacing: 0) {
        SectionHeaderCompact(title: "가게 정보", icon: DesignSystemAsset.info.swiftUIImage)
        
        ExpandableTextView(text: cakeShopDetail.shopDescription, 
                           font: .pretendard(size: 15),
                           lineLimit: 5)
        .foregroundStyle(DesignSystemAsset.gray70.swiftUIColor)
      }
      .padding(.horizontal, 4)
    }
  }
}


// MARK: - Preview

// Success Scenario

import PreviewSupportCakeShop

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(CakeShopDetailViewModel.self) { resolver in
    let cakeShopDetailUseCase = MockCakeShopDetailUseCase()
    let cakeImagesByShopIdUseCase = MockCakeImagesByShopIdUseCase()
    let cakeShopAdditionalInfoUseCase = MockCakeShopAdditionalInfoUseCase()
    
    let viewModel = CakeShopDetailViewModel(shopId: 0,
                                            cakeShopDetailUseCase: cakeShopDetailUseCase,
                                            cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
                                            cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase)
    viewModel.fetchCakeShopDetail()
    return viewModel
  }
  
  return CakeShopDetailView()
}

// NoExists, Failure Scenario

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(CakeShopDetailViewModel.self) { resolver in
    let cakeShopDetailUseCase = MockCakeShopDetailUseCase(scenario: .noExists)
    let cakeImagesByShopIdUseCase = MockCakeImagesByShopIdUseCase(scenario: .failure)
    let cakeShopAdditionalInfoUseCase = MockCakeShopAdditionalInfoUseCase(scenario: .failure)
    
    let viewModel = CakeShopDetailViewModel(shopId: 0,
                                            cakeShopDetailUseCase: cakeShopDetailUseCase,
                                            cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
                                            cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase)
    viewModel.fetchCakeShopDetail()
    return viewModel
  }
  
  return CakeShopDetailView()
}
