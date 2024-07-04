//
//  UploadSingleCakeShopView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/27/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import CommonUtil
import DesignSystem

import DomainCakeShop

import DIContainer

struct UploadSingleCakeShopView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: UploadSingleCakeShopViewModel
  
  
  // MARK: - Initializers
  
  init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(UploadSingleCakeShopViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  
  // MARK: - Views
  
  var body: some View {
    ScrollView {
      VStack(spacing: 40) {
        VStack(spacing: 0) {
          SectionHeaderLarge(title: "🍰 기본 정보")
          
          VStack(spacing: 0) {
            SectionHeaderCompact(title: "케이크샵 이름 *")
            CKTextField(text: $viewModel.shopName, placeholder: "케이크샵 이름을 입력해주세요")
          }
          
          VStack(spacing: 0) {
            SectionHeaderCompact(title: "샵 한 줄 소개")
            CKTextField(text: $viewModel.shopBio, placeholder: "케이크샵 한 줄 소개를 입력해주세요", supportsMultiline: true)
          }
          
          VStack(spacing: 0) {
            SectionHeaderCompact(title: "샵 상세 설명")
            CKTextField(text: $viewModel.shopDescription, placeholder: "케이크샵 상세 소개를 입력해주세요", supportsMultiline: true)
          }
        }
        .padding(.horizontal, 24)
        
        VStack(spacing: 0) {
          SectionHeaderLarge(title: "📍 주소")
          
          HStack {
            VStack(spacing: 0) {
              SectionHeaderCompact(title: "가게 주소 *")
              CKTextField(text: $viewModel.shopAddress, placeholder: "케이크샵 상세 소개를 입력해주세요")
            }
            
            VStack(spacing: 0) {
              SectionHeaderCompact(title: "Latitude *")
              CKTextField(text: $viewModel.latitude, placeholder: "Latitude를 입력해주세요")
            }
            
            VStack(spacing: 0) {
              SectionHeaderCompact(title: "Longitude *")
              CKTextField(text: $viewModel.longitude, placeholder: "Longitude를 입력해주세요")
            }
          }
        }
        .padding(.horizontal, 24)
        
        VStack(spacing: 0) {
          SectionHeaderLarge(title: "🕸️ 외부 링크")
          
          HStack {
            ForEach(Array(viewModel.externalShopLinks.enumerated()), id: \.offset) { index, externalLink in
              VStack(spacing: 0) {
                SectionHeaderCompact(title: externalLink.linkType.displayName)
                CKTextField(text: $viewModel.externalShopLinks[index].linkPath, placeholder: "https://abc.com")
              }
            }
          }
        }
        .padding(.horizontal, 24)
        
        VStack(spacing: 0) {
          SectionHeaderLarge(title: "🗓️ 영업일")
            .padding(.horizontal, 24)
          
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
              ForEach(Array(viewModel.workingDaysWithTime.enumerated()), id: \.offset) { index, workingDay in
                VStack {
                  SectionHeaderCompact(title: workingDay.workingDay.displayName)
                  CKTextField(text: $viewModel.workingDaysWithTime[index].startTime,
                              placeholder: index == 0 ? "시작 시간" : "00:00",
                              supportsMultiline: true)
                  
                  CKTextField(text: $viewModel.workingDaysWithTime[index].endTime,
                              placeholder: index == 0 ? "종료 시간" : "00:00",
                              supportsMultiline: true)
                }
                .frame(width: 120)
              }
            }
            .padding(.horizontal, 24)
          }
        }
        
        VStack(spacing: 0) {
          SectionHeaderLarge(title: "🧁 기타")
          
          VStack(spacing: 0) {
            SectionHeaderCompact(title: "사업자 번호")
            CKTextField(text: $viewModel.businessNumber, placeholder: "사업자 번호를 입력해주세요")
          }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 200)
      }
    }
    .navigationTitle("단일 등록")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      Button("등록") {
        DialogManager.shared.showDialog(
          title: "업로드",
          message: "정말 이 상태로 업로드 할까요?",
          primaryButtonTitle: "확인",
          primaryButtonAction: .custom({
            viewModel.uploadCakeShop()
          }), secondaryButtonTitle: "취소",
          secondaryButtonAction: .cancel)
      }
    }
    .onReceive(viewModel.$cakeShopUploadState, perform: { uploadState in
      switch uploadState {
      case .failure:
        DialogManager.shared.showDialog(.unknownError())
      case .invalidCoordinate:
        DialogManager.shared.showDialog(title: "위도 경도 오류",
                                        message: "위도 경도 값이 올바르지 않아요.",
                                        primaryButtonTitle: "확인",
                                        primaryButtonAction: .cancel)
      case .loading:
        LoadingManager.shared.startLoading()
        return
      case .success:
        DialogManager.shared.showDialog(title: "업로드 성공",
                                        message: "업로드에 성공하였어요!",
                                        primaryButtonTitle: "확인",
                                        primaryButtonAction: .custom({
          viewModel.resetFields()
        }))
        
      case .wrongWorkingDayFormat:
        DialogManager.shared.showDialog(title: "영업 시간 설정 오류",
                                        message: "영업시간이 올바르지 않아요.\n00:00 형식인지 확인해주세요",
                                        primaryButtonTitle: "확인",
                                        primaryButtonAction: .cancel)
        
      case .emptyRequiredField:
        DialogManager.shared.showDialog(title: "필수 입력 정보",
                                        message: "필수로 입력돼야하는 정보가 입력되지 않았어요.",
                                        primaryButtonTitle: "확인",
                                        primaryButtonAction: .cancel)
        
      default:
        break
      }
      
      LoadingManager.shared.stopLoading()
    })
  }
}


// MARK: - Preview

import PreviewSupportCakeShopAdmin

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(UploadSingleCakeShopViewModel.self) { _ in
    let useCase = MockUploadCakeShopUseCase()
    return UploadSingleCakeShopViewModel(uploadCakeShopUseCase: useCase)
  }
  
  return UploadSingleCakeShopView()
}
