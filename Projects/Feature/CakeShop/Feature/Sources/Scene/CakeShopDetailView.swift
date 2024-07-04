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
import ExpandableText

import Kingfisher

import DIContainer
import Router

import DomainCakeShop

public struct CakeShopDetailView: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  @StateObject var viewModel: CakeShopDetailViewModel
  
  @State private var selectedDetailSection = CakeShopContentsSection.DetailSection.images
  
  @State private var navigationTitleOpacity: CGFloat = 0
  
  
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
        NavigationBar(
          isDividerShown: false,
          leadingContent: {
          Button {
            router.navigateBack()
          } label: {
            Image(systemName: "arrow.left")
              .font(.system(size: 20))
              .foregroundColor(DesignSystemAsset.black.swiftUIColor)
          }
        }, centerContent: {
          if let shopDetail = viewModel.cakeShopDetail {
            Text(shopDetail.shopName)
              .font(.pretendard(size: 17, weight: .bold))
              .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
              .opacity(navigationTitleOpacity)
          }
        })
        
        if let cakeShopDetail = viewModel.cakeShopDetail {
          ScrollViewOffset { offset in
            navigationTitleOpacity = min(1, -offset / 100)
          } content: {
            VStack(spacing: 20) {
              headerView(cakeShopDetail: cakeShopDetail)
                .padding(.horizontal, 24)
                .padding(.top, 12)
              
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
        
        if let shopDetail = viewModel.cakeShopDetail {
//          ZStack {
//            bottomPromptButton(shopDetail: shopDetail)
//              .offset(y: selectedDetailSection == .order ? 0 : 200)
//              .animation(.smooth, value: selectedDetailSection)
//              .opacity(viewModel.isOwned ? 0 : 1)
//          }
//          .background {
//            bottomGeneralButtons(shopDetail: shopDetail)
//              .offset(y: selectedDetailSection != .order ? 0 : 200)
//              .animation(.snappy, value: selectedDetailSection)
//          }
          bottomGeneralButtons(shopDetail: shopDetail)
            .offset(y: selectedDetailSection != .order ? 0 : 200)
            .animation(.snappy, value: selectedDetailSection)
        }
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
    VStack(spacing: 24) {
      VStack(alignment: .leading, spacing: 24) {
        HStack(alignment: .top, spacing: 16) {
          if let thumbnailImageUrl = cakeShopDetail.thumbnailImageUrl {
            KFImage(URL(string: thumbnailImageUrl))
              .resizable()
              .scaledToFill()
              .size(92)
              .background(DesignSystemAsset.gray10.swiftUIColor)
              .overlay {
                Circle()
                  .stroke(DesignSystemAsset.gray10.swiftUIColor, lineWidth: 0.5)
              }
              .clipShape(Circle())
          } else {
            Circle()
              .fill(Color(hex: "FFA9DC"))
              .size(92)
              .overlay {
                DesignSystemAsset.cakeFaceTongue.swiftUIImage
                  .resizable()
                  .scaledToFit()
                  .frame(width: 72)
              }
          }

          VStack(spacing: 10) {
            VStack(spacing: 4) {
              Text(cakeShopDetail.shopName)
                .font(.pretendard(size: 24, weight: .bold))
                .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
              
              Text(cakeShopDetail.shopBio)
                .font(.pretendard(size: 13, weight: .regular))
                .foregroundStyle(DesignSystemAsset.gray40.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            WorkingDayInfoView(workingDays: cakeShopDetail.workingDays)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        ExternalShopLinksView(externalShopLinks: cakeShopDetail.externalShopLinks,
                              emptyLinkButtonAction: {
          if viewModel.isOwned {
            if viewModel.isMyShop {
              /// 사장의 경우 외부 링크 즉시 수정 가능하도록 이동
              if let cakeShopDetail = viewModel.cakeShopDetail {
                router.navigate(to: PublicCakeShopDestination.editExternalLink(shopId: cakeShopDetail.shopId,
                                                                               externalLinks: cakeShopDetail.externalShopLinks))
              }
            } else {
              DialogManager.shared.showDialog(
                title: "외부링크 등록",
                message: "외부링크는 케이크샵 사장님만 등록 가능해요.",
                primaryButtonTitle: "확인",
                primaryButtonAction: .cancel)

            }
          } else {
            DialogManager.shared.showDialog(
              title: "외부링크 등록",
              message: "외부링크는 케이크샵 사장님만 등록 가능해요.\n혹시 \"\(cakeShopDetail.shopName)\"(이)가 내 케이크샵이라면 사장님 인증을 완료하고 외부 링크를 등록해보세요!",
              primaryButtonTitle: "사장님 인증",
              primaryButtonAction: .custom({
                router.navigate(to: PublicCakeShopDestination.businessCertification(targetShopId: cakeShopDetail.shopId))
              }), secondaryButtonTitle: "취소",
              secondaryButtonAction: .cancel)
          }
        })
      }
      
      VStack(spacing: 0) {
        SectionHeaderCompact(title: "가게 정보", icon: DesignSystemAsset.info.swiftUIImage)
        
        ExpandableText(cakeShopDetail.shopDescription)
          .font(.pretendard(size: 13))
          .lineLimit(3)
          .moreButtonText("더보기")
          .moreButtonFont(.pretendard(size: 13))
          .moreButtonColor(DesignSystemAsset.black.swiftUIColor)
          .expandAnimation(.snappy)
          .trimMultipleNewlinesWhenTruncated(false)
          .foregroundStyle(DesignSystemAsset.gray70.swiftUIColor)
      }
      .padding(.horizontal, 4)
    }
  }
  
  private func bottomPromptButton(shopDetail: CakeShopDetail) -> some View {
    HStack {
      Text("\(shopDetail.shopName) 샵이 어서 입점하길 원한다면?\n따봉을 눌러 사장님을 재촉해 보세요!")
        .font(.pretendard(size: 15, weight: .medium))
        .foregroundStyle(.white)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Button {
        // 따봉 action
      } label: {
        VStack(spacing: 5) {
          DesignSystemAsset.thumbsUp.swiftUIImage
            .resizable()
            .scaledToFit()
            .size(24)
          
          Text("3,300")
            .font(.pretendard(size: 13, weight: .bold))
        }
        .foregroundStyle(.white)
        .padding(4)
      }
      .modifier(BouncyPressEffect())
    }
    .padding(.vertical, 8)
    .padding(.horizontal, 28)
    .background(DesignSystemAsset.black.swiftUIColor.ignoresSafeArea())
  }
  
  private func bottomGeneralButtons(shopDetail: CakeShopDetail) -> some View {
    HStack {
      Button {
        viewModel.toggleLike()
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
      } label: {
        RoundedRectangle(cornerRadius: 20)
          .stroke(DesignSystemAsset.gray30.swiftUIColor, lineWidth: 1)
          .background(Color.white.clipShape(RoundedRectangle(cornerRadius: 20)))
          .frame(width: 76, height: 64)
          .overlay {
            Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
              .font(.system(size: 24))
              .foregroundStyle(viewModel.isLiked ? DesignSystemAsset.brandcolor2.swiftUIColor : DesignSystemAsset.black.swiftUIColor)
          }
      }
      .modifier(BouncyPressEffect())
      .onReceive(viewModel.$likeUpdatingState, perform: { state in
        if case .sessionExpired = state {
          DialogManager.shared.showDialog(
            title: "로그인 필요",
            message: "로그인이 필요한 기능이에요.\n로그인하여 더 많은 기능을 누려보세요!",
            primaryButtonTitle: "확인",
            primaryButtonAction: .cancel)
        }
      })
      
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


// MARK: - Preview

// Success Scenario

import PreviewSupportCakeShop
import PreviewSupportUser

#Preview("Success") {
  let diContainer = DIContainer.shared.container
  diContainer.register(CakeShopDetailViewModel.self) { resolver in
    let cakeShopDetailUseCase = MockCakeShopDetailUseCase()
    let cakeImagesByShopIdUseCase = MockCakeImagesByShopIdUseCase()
    let cakeShopAdditionalInfoUseCase = MockCakeShopAdditionalInfoUseCase()
    let likeCakeShopUseCase = MockLikeCakeShopUseCase()
    let cakeShopOwnedStateUseCase = MockCakeShopOwnedStateUseCase()
    let myShopIdUseCase = MockMyShopIdUseCase()
    
    let viewModel = CakeShopDetailViewModel(shopId: 0,
                                            cakeShopDetailUseCase: cakeShopDetailUseCase,
                                            cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
                                            cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase,
                                            likeCakeShopUseCase: likeCakeShopUseCase,
                                            cakeShopOwnedStateUseCase: cakeShopOwnedStateUseCase,
                                            myShopIdUseCase: myShopIdUseCase)
    return viewModel
  }
  
  return CakeShopDetailView()
}

// NoExists, Failure Scenario

#Preview("Failure") {
  let diContainer = DIContainer.shared.container
  diContainer.register(CakeShopDetailViewModel.self) { resolver in
    let cakeShopDetailUseCase = MockCakeShopDetailUseCase(scenario: .noExists)
    let cakeImagesByShopIdUseCase = MockCakeImagesByShopIdUseCase(scenario: .failure)
    let cakeShopAdditionalInfoUseCase = MockCakeShopAdditionalInfoUseCase(scenario: .failure)
    let likeCakeShopUseCase = MockLikeCakeShopUseCase()
    let cakeShopOwnedStateUseCase = MockCakeShopOwnedStateUseCase()
    let myShopIdUseCase = MockMyShopIdUseCase()
    
    let viewModel = CakeShopDetailViewModel(shopId: 0,
                                            cakeShopDetailUseCase: cakeShopDetailUseCase,
                                            cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
                                            cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase,
                                            likeCakeShopUseCase: likeCakeShopUseCase,
                                            cakeShopOwnedStateUseCase: cakeShopOwnedStateUseCase,
                                            myShopIdUseCase: myShopIdUseCase)
    return viewModel
  }
  
  return CakeShopDetailView()
}
