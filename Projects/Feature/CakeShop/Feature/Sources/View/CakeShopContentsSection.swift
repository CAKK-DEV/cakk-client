//
//  CakeShopContentsSection.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil
import DesignSystem

import DIContainer
import Router

import DomainCakeShop

import MapKit

struct CakeShopContentsSection: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  @EnvironmentObject private var viewModel: CakeShopDetailViewModel
  
  private let sectionItems = DetailSection.allCases.map { $0.item }
  @Binding var selectedSection: DetailSection
  
  enum DetailSection: String, CaseIterable {
    case images = "사진"
    case order = "주문하기"
    case detail = "가게 상세 정보"
    
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
          FailureStateView(title: "아직 등록된 메뉴가 없어요!",
                           buttonTitle: "사장님 인증하고 메뉴 등록하기!",
                           buttonAction: {
            // TDOO: 사장님 인증 페이지로 이동
          }, buttonDescription: "사장님 인증이 완료되면 현재 보고있는 케이크샵의\n모든 수정 권한은  사장님께 넘어가요!")
          .frame(height: 400)
          
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
        FlexibleGridView(columns: 2, data: viewModel.cakeImages) { cakeImage in
          AsyncImage(
            url: URL(string: cakeImage.imageUrl),
            transaction: Transaction(animation: .easeInOut)
          ) { phase in
            switch phase {
            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .onAppear {
                  if cakeImage.id == viewModel.cakeImages.last?.id {
                    viewModel.fetchMoreCakeImages()
                  }
                }
                .onTapGesture {
                  router.presentFullScreenSheet(destination: FullScreenSheetDestination.imageFullScreen(imageUrl: cakeImage.imageUrl))
                }
            default:
              RoundedRectangle(cornerRadius: 14)
                .fill(DesignSystemAsset.gray20.swiftUIColor)
                .aspectRatio(3/4, contentMode: .fit)
            }
          }
        }
        
        if viewModel.imageFetchingState == .loading {
          ProgressView()
        }
      }
      .padding(.vertical, 20)
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
      VStack(spacing: 28) {
        if let additionalInfo = viewModel.additionalInfo {
          VStack(spacing: 16) {
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
                    Text("휴무")
                      .font(.pretendard())
                      .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
                  }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
              }
            }
            .padding(.horizontal, 28)
            
            VStack(spacing: 0) {
              SectionHeaderCompact(title: "가게 위치", icon: DesignSystemAsset.marker.swiftUIImage)
              
              Text(additionalInfo.location.address)
                .font(.pretendard())
                .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
              
              ShopLocationMapView(shopName: viewModel.cakeShopDetail?.shopName ?? "",
                                  latitude: additionalInfo.location.latitude,
                                  longitude: additionalInfo.location.longitude)
              .padding(.top, 12)
            }
            .padding(.horizontal, 28)
          }
        }
      }
    }
  }
}


// MARK: - Preview

import PreviewSupportCakeShop
import PreviewSupportUser

#Preview {
  struct PreviewContent: View {
    
    @State private var selectedSection = CakeShopContentsSection.DetailSection.detail
    @StateObject var viewModel: CakeShopDetailViewModel
    
    init() {
      let cakeShopDetailUseCase = MockCakeShopDetailUseCase()
      let cakeImagesByShopIdUseCase = MockCakeImagesByShopIdUseCase()
      let cakeShopAdditionalInfoUseCase = MockCakeShopAdditionalInfoUseCase()
      let likeCakeShopUseCase = MockLikeCakeShopUseCase()
      let viewModel = CakeShopDetailViewModel(shopId: 0,
                                              cakeShopDetailUseCase: cakeShopDetailUseCase,
                                              cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
                                              cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase,
                                              likeCakeShopUseCase: likeCakeShopUseCase)
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


#Preview {
  struct PreviewContent: View {
    
    @State private var selectedSection = CakeShopContentsSection.DetailSection.detail
    @StateObject var viewModel: CakeShopDetailViewModel
    
    init() {
      let cakeShopDetailUseCase = MockCakeShopDetailUseCase(scenario: .failure)
      let cakeImagesByShopIdUseCase = MockCakeImagesByShopIdUseCase(scenario: .failure)
      let cakeShopAdditionalInfoUseCase = MockCakeShopAdditionalInfoUseCase(scenario: .failure)
      let likeCakeShopUseCase = MockLikeCakeShopUseCase()
      
      let viewModel = CakeShopDetailViewModel(shopId: 0,
                                              cakeShopDetailUseCase: cakeShopDetailUseCase,
                                              cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
                                              cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase,
                                              likeCakeShopUseCase: likeCakeShopUseCase)
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
