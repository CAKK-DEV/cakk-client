//
//  CakeShopDetailView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/27/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem
import Kingfisher

import DomainCakeShop
import DIContainer
import Router

struct CakeShopDetailView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: CakeShopDetailViewModel
  let columns = [GridItem(.adaptive(minimum: 88, maximum: 120), spacing: 6)]
  
  @EnvironmentObject private var router: Router
  
  
  // MARK: - Initializers
  
  init(shopId: Int) {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(CakeShopDetailViewModel.self)!
    viewModel.shopId = shopId
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        if let shopDetail = viewModel.cakeShopDetail {
          shopDetailSection(shopDetail: shopDetail)
        }
        
        if let additionalInfo = viewModel.additionalInfo {
          additionalInfoSection(additionalInfo: additionalInfo)
        }
        
        cakeImagesSection()
      }
      .padding(.horizontal, 24)
      .padding(.top, 20)
      .padding(.bottom, 100)
    }
    .navigationTitle(viewModel.cakeShopDetail?.shopName ?? "로딩중..")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Menu {
          Button("기본정보 수정") {
            if let cakeShopDetail = viewModel.cakeShopDetail {
              router.navigate(to: CakeShopDetailDestination.editBasicInfo(cakeShopDetail: cakeShopDetail))
            }
          }
          
          Button("외부링크 수정") {
            if let cakeShopDetail = viewModel.cakeShopDetail {
              router.navigate(to: CakeShopDetailDestination.editExternalLink(shopId: cakeShopDetail.shopId, externalLinks: cakeShopDetail.externalShopLinks))
            }
          }
          
          Button("영업시간 수정") {
            if let cakeShopDetail = viewModel.cakeShopDetail,
               let additionalInfo = viewModel.additionalInfo {
              router.navigate(to: CakeShopDetailDestination.editWorkingDay(shopId: cakeShopDetail.shopId, workingDaysWithTime: additionalInfo.workingDaysWithTime))
            }
          }
          
          Button("가게위치 수정") {
            if let cakeShopDetail = viewModel.cakeShopDetail,
               let additionalInfo = viewModel.additionalInfo {
              router.navigate(to: CakeShopDetailDestination.editAddress(shopId: cakeShopDetail.shopId, cakeShopLocation: additionalInfo.location))
            }
          }
          
          Button("케이크 이미지 수정") {
            if let cakeShopDetail = viewModel.cakeShopDetail {
              router.navigate(to: CakeShopDetailDestination.editCakeImages(shopId: cakeShopDetail.shopId))
            }
          }
        } label: {
          Image(systemName: "ellipsis.circle")
            .imageScale(.large)
        }
      }
    }
    .onAppear {
      viewModel.fetchCakeShopDetail()
      viewModel.fetchAdditionalInfo()
      viewModel.fetchCakeImages()
    }
  }
  
  private func shopDetailSection(shopDetail: CakeShopDetail) -> some View {
    VStack(spacing: 24) {
      HStack(spacing: 12) {
        if let thumbnailImageUrl = shopDetail.thumbnailImageUrl {
          KFImage(URL(string: thumbnailImageUrl))
            .resizable()
            .scaledToFill()
            .frame(width: 92, height: 92)
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
                .size(80)
            }
        }
        
        VStack(spacing: 4) {
          Text(shopDetail.shopName)
            .font(.pretendard(size: 20, weight: .bold))
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
          
          Text(shopDetail.shopBio)
            .font(.pretendard(size: 13))
            .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
        }
      }
      
      VStack(spacing: 0) {
        SectionHeaderCompact(title: "가게 정보")
        
        Text(shopDetail.shopDescription)
          .font(.pretendard(size: 13, weight: .medium))
          .foregroundStyle(DesignSystemAsset.gray70.swiftUIColor)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      
      VStack(spacing: 0) {
        SectionHeaderCompact(title: "외부 링크")
        
        VStack(spacing: 4) {
          ForEach(shopDetail.externalShopLinks, id: \.linkType) { externalLink in
            HStack(spacing: 8) {
              Text("\(externalLink.linkType)")
                .font(.pretendard(size: 13, weight: .medium))
                .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
                .padding(4)
                .background(RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.2)))
              
              Text(externalLink.linkPath)
                .font(.pretendard(size: 13, weight: .medium))
                .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
          }
        }
      }
    }
  }

  private func additionalInfoSection(additionalInfo: CakeShopAdditionalInfo) -> some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(title: "영업일")
      
      VStack(spacing: 4) {
        ForEach(additionalInfo.workingDaysWithTime, id: \.workingDay) { workingDayWithTime in
          HStack(spacing: 8) {
            Text(workingDayWithTime.workingDay.displayName)
              .font(.pretendard(size: 13, weight: .medium))
              .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
              .padding(4)
              .background(RoundedRectangle(cornerRadius: 4).fill(Color.gray.opacity(0.3)))
            
            Text("\(workingDayWithTime.startTime) ~ \(workingDayWithTime.endTime)")
              .font(.pretendard(size: 13, weight: .medium))
              .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
  
  private func cakeImagesSection() -> some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(title: "케이크 이미지")
      
      if viewModel.cakeImages.isEmpty {
        FailureStateView(title: "등록된 이미지가 없습니다.")
          .padding(60)
      } else {
        LazyVGrid(columns: columns, spacing: 6) {
          ForEach(viewModel.cakeImages, id: \.id) { cakeImage in
            RoundedRectangle(cornerRadius: 12)
              .fill(Color.gray.opacity(0.3))
              .aspectRatio(1/1, contentMode: .fit)
              .overlay {
                KFImage(URL(string: cakeImage.imageUrl))
                  .resizable()
                  .scaledToFill()
              }
              .clipShape(RoundedRectangle(cornerRadius: 12))
              .onFirstAppear {
                if viewModel.cakeImages.last?.id == cakeImage.id {
                  viewModel.fetchMoreCakeImages()
                }
              }
              .onTapGesture {
                router.navigate(to: EditCakeShopDestination.editCakeImageDetail(imageId: cakeImage.id))
              }
          }
          
          if viewModel.imageFetchingState == .loadMore {
            ProgressView()
          }
        }
      }
    }
  }
}


// MARK: - Preview

import PreviewSupportCakeShop

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(CakeShopDetailViewModel.self) { resolver in
    let cakeShopDetailUseCase = MockCakeShopDetailUseCase()
    let cakeImagesByShopIdUseCase = MockCakeImagesByShopIdUseCase()
    let cakeShopAdditionalInfoUseCase = MockCakeShopAdditionalInfoUseCase()
    
    let viewModel = CakeShopDetailViewModel(
      shopId: 0,
      cakeShopDetailUseCase: cakeShopDetailUseCase,
      cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
      cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase)
    viewModel.fetchCakeShopDetail()
    return viewModel
  }
  
  return NavigationStack {
    CakeShopDetailView(shopId: 0)
  }
}
