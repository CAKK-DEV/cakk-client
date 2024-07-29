//
//  CakeShopContentsSection.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import CommonUtil
import DesignSystem

import Kingfisher

import DIContainer
import Router

import CommonDomain
import DomainCakeShop

import MapKit

import Logger

struct CakeShopContentsSection: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  @EnvironmentObject private var viewModel: CakeShopDetailViewModel
  
  private let sectionItems = DetailSection.allCases.map { $0.item }
  @Binding var selectedSection: DetailSection
  
  enum DetailSection: String, CaseIterable {
    case images = "사진"
    case order = "주문하기"
    case detail = "상세정보"
    
    var item: CKSegmentItem {
      CKSegmentItem(title: rawValue)
    }
  }
  

  // MARK: - Initializers
  
  public init(selectedSection: Binding<DetailSection>) {
    _selectedSection = selectedSection
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    LazyVStack(pinnedViews: [.sectionHeaders]) {
      Section {
        switch selectedSection {
        case .images:
          imageSection()
        
        case .order:
          if viewModel.isOwned {
            if viewModel.isMyShop {
              FailureStateView(title: "기능 준비중이에요")
                .frame(height: 400)
            } else {
              FailureStateView(title: "메뉴 준비중이에요")
                .frame(height: 400)
            }
          } else {
            FailureStateView(title: "아직 등록된 메뉴가 없어요!",
                             buttonTitle: "사장님 인증하고 메뉴 등록하기!",
                             buttonAction: {
              if let shopId = viewModel.cakeShopDetail?.shopId {
                router.navigate(to: PublicCakeShopDestination.businessCertification(targetShopId: shopId))
              }
            }, buttonDescription: "사장님 인증이 완료되면 현재 보고있는 케이크샵의\n모든 수정 권한은  사장님께 넘어가요!")
            .frame(height: 400)
          }
          
        case .detail:
          detailSection()
        }
      } header: {
        CKSegmentedControl(items: sectionItems, selection: .init(get: {
          selectedSection.item
        }, set: { item in
          self.selectedSection = DetailSection(rawValue: item.title)!
        }))
      }
    }
  }
  
  @ViewBuilder
  private func imageSection() -> some View {
    if viewModel.imageFetchingState == .failure {
      FailureStateView(title: "이미지 로딩에 실패하였어요",
                       buttonTitle: "다시 시도",
                       buttonAction: {
        viewModel.fetchCakeImages()
      })
      .frame(height: 400)
    } else {
      VStack(spacing: 100) {
        FlexibleGridView(data: viewModel.cakeImages) { cakeImage in
          CakeImageGridItem(imageUrlString: cakeImage.imageUrl)
            .background(DesignSystemAsset.gray10.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .onAppear {
              if cakeImage.id == viewModel.cakeImages.last?.id {
                viewModel.fetchMoreCakeImages()
              }
            }
            .onTapGesture {
              router.presentSheet(destination: CakeShopDetailFullScreenSheetDestination.imageFullScreen(imageUrl: cakeImage.imageUrl),
                                  sheetStyle: .fullScreen)
            }
        }
        
        if viewModel.imageFetchingState == .loading {
          ProgressView()
        }
      }
      .padding(.vertical, 12)
      .padding(.horizontal, 12)
      .onFirstAppear {
        viewModel.fetchCakeImages()
      }
    }
  }
  
  @ViewBuilder
  private func detailSection() -> some View {
    switch viewModel.additionalInfoFetchingState {
    case .failure:
      FailureStateView(title: "상세 정보 볼러오기에 실패하였어요.",
                       buttonTitle: "다시 시도",
                       buttonAction: {
        viewModel.fetchAdditionalInfo()
      })
      .frame(height: 400)
      
    case .idle, .loading:
      Color.clear
        .frame(height: 400)
        .overlay {
          ProgressView()
        }
        .onFirstAppear {
          viewModel.fetchAdditionalInfo()
        }
      
    case .success:
      if let additionalInfo = viewModel.additionalInfo {
        VStack(spacing: 28) {
          VStack {
            SectionHeaderCompact(title: "가게 영업 시간", icon: DesignSystemAsset.clock.swiftUIImage)
              .padding(.horizontal, 28)
              .padding(.top, 20)
            
            VStack(spacing: 5) {
              ForEach(WorkingDay.allCases, id: \.self) { workingDay in
                HStack {
                  Text(workingDay.displayName)
                    .font(.pretendard(size: 15, weight: .bold))
                    .foregroundStyle(workingDay == .sun || workingDay == .sat
                                     ? DesignSystemAsset.brandcolor2.swiftUIColor
                                     : DesignSystemAsset.black.swiftUIColor)
                  
                  if let workingDayWithTime = additionalInfo.workingDaysWithTime.filter({ $0.workingDay == workingDay }).first {
                    Text(workingDayWithTime.makeBusinessHourFormattedString() ?? "불러오기 실패")
                      .font(.pretendard())
                      .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
                  } else {
                    Text("정보 없음")
                      .font(.pretendard())
                      .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
                  }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
              }
            }
            .padding(.horizontal, 28)
          }
          
          VStack(spacing: 4) {
            SectionHeaderCompact(title: "가게 위치", icon: DesignSystemAsset.marker.swiftUIImage)
            
            Text(additionalInfo.location.address)
              .font(.pretendard())
              .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
              .frame(maxWidth: .infinity, alignment: .leading)
              .multilineTextAlignment(.leading)
            
            ShopLocationMapView(annotationItem: .init(shopName: viewModel.cakeShopDetail?.shopName ?? "",
                                                      latitude: additionalInfo.location.latitude,
                                                      longitude: additionalInfo.location.longitude))
            .padding(.top, 12)
            .contentShape(Rectangle())
            .onTapGesture {
              DialogManager.shared.showDialog(
                title: "지도 열기",
                message: "지도를 열면 네이버 지도로 이동하게 됩니다.\n지도를 열까요?",
                primaryButtonTitle: "지도 열기",
                primaryButtonAction: .custom({
                  if let url = viewModel.makeNaverMapUrl() {
                    UIApplication.shared.open(url, options: [:]) { successToOpenUrl in
                      if successToOpenUrl {
                        /// 네이버 맵이 설치되어있는 경우 네이버 지도에 검색어 검색 후 결과 표시
                        if let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id311867728") {
                          UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                        }
                      } else {
                        /// 네이버 맵이 설치되지 않은 경우 앱스토어(네이버지도)로 이동
                        if let url = URL(string: "https://apps.apple.com/kr/app/naver-map-navigation/id311867728?l=ko-GB") {
                          UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                      }
                    }
                  }
                }),
                secondaryButtonTitle: "취소",
                secondaryButtonAction: .cancel)
            }
          }
          .padding(.horizontal, 28)
        }
        .padding(.bottom, 100)
      }
    }
  }
}


// MARK: - Preview

import PreviewSupportCakeShop
import PreviewSupportUser
import PreviewSupportSearch

#Preview("Success") {
  struct PreviewContent: View {
    
    @State private var selectedSection = CakeShopContentsSection.DetailSection.detail
    @StateObject var viewModel: CakeShopDetailViewModel
    
    init() {
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
      _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
      ScrollView {
        CakeShopContentsSection(selectedSection: $selectedSection)
          .environmentObject(viewModel)
      }
      .onAppear {
        viewModel.fetchCakeShopDetail()
      }
    }
  }
  
  return PreviewContent()
}


#Preview("Failure") {
  struct PreviewContent: View {
    
    @State private var selectedSection = CakeShopContentsSection.DetailSection.detail
    @StateObject var viewModel: CakeShopDetailViewModel
    
    init() {
      let cakeShopDetailUseCase = MockCakeShopDetailUseCase(scenario: .failure)
      let cakeImagesByShopIdUseCase = MockCakeImagesByShopIdUseCase(scenario: .failure)
      let cakeShopAdditionalInfoUseCase = MockCakeShopAdditionalInfoUseCase(scenario: .failure)
      let likeCakeShopUseCase = MockLikeCakeShopUseCase()
      let cakeShopOwnedStateUseCase = MockCakeShopOwnedStateUseCase(scenario: .notOwned)
      let myShopIdUseCase = MockMyShopIdUseCase()
      
      let viewModel = CakeShopDetailViewModel(shopId: 0,
                                              cakeShopDetailUseCase: cakeShopDetailUseCase,
                                              cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
                                              cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase,
                                              likeCakeShopUseCase: likeCakeShopUseCase,
                                              cakeShopOwnedStateUseCase: cakeShopOwnedStateUseCase,
                                              myShopIdUseCase: myShopIdUseCase)
      _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
      ScrollView {
        CakeShopContentsSection(selectedSection: $selectedSection)
          .environmentObject(viewModel)
      }
    }
  }
  
  return PreviewContent()
}
