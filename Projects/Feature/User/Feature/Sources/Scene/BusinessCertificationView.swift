//
//  BusinessCertificationView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import PhotosUI

import CommonUtil
import DesignSystem

import LinkNavigator
import DIContainer

import AnalyticsService

public struct BusinessCertificationView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: BusinessCertificationViewModel
  
  @State private var isBusinessCertPhotoPickerShown = false
  @State private var isIdCardPhotoPickerShown = false
  enum PhotoPickerType {
    case businessCert
    case idCard
  }
  
  private let analytics: AnalyticsService?
  private let navigator: LinkNavigatorType?
  
  
  // MARK: - Initializers
  
  
  public init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(BusinessCertificationViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
    
    self.analytics = diContainer.resolve(AnalyticsService.self)
    self.navigator = diContainer.resolve(LinkNavigatorType.self)
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    ZStack {
      VStack(spacing: 0) {
        NavigationBar(leadingContent: {
          Button {
            navigator?.back(isAnimated: true)
          } label: {
            Image(systemName: "arrow.left")
              .font(.system(size: 20))
              .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
              .size(40)
          }
          .modifier(BouncyPressEffect())
        }, centerContent: {
          Text("사장님 인증")
            .font(.pretendard(size: 17, weight: .bold))
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        })
        
        ScrollView {
          VStack(spacing: 12) {
            businessCertImageInputSection()
            idCardImageInputSection()
            contactInputSection()
            additionalInputSection()
          }
          .padding(.top, 12)
          .padding(.bottom, 200)
        }
      }
      
      VStack {
        CKButtonLargeMessage(title: "사장님 인증 요청 보내기",
                             message: "인증이 완료되면 알림을 보내드릴게요!",
                             fixedSize: .infinity, action: {
          viewModel.uploadCertifications()
        }, isLoading: .constant(viewModel.verificationState == .loading))
        .padding(.horizontal, 28)
        .padding(.bottom, 16)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    .onAppear {
      analytics?.logEngagement(view: self)
    }
    .onReceive(viewModel.$verificationState, perform: { state in
      switch state {
      case .contactRequired:
        DialogManager.shared.showDialog(
          title: "연락처 입력",
          message: "승인 과정 중 연락드렸을 때 받을 수 있는 연락처를 입력해 주세요.",
          primaryButtonTitle: "확인",
          primaryButtonAction: .cancel
        )
        
      case .imageRequired:
        DialogManager.shared.showDialog(
          title: "이미지 첨부 안 됨",
          message: "승인에 필요한 필수 이미지들을 첨부해주세요.",
          primaryButtonTitle: "확인",
          primaryButtonAction: .cancel
        )
        
      case .loading:
        LoadingManager.shared.startLoading()
        return
        
      case .success:
        DialogManager.shared.showDialog(
          title: "요청 완료",
          message: "사장님 인증 요청이 완료 되었어요!\n인증정보 확인 후 빠른 시일 내로 연락 드릴게요.",
          primaryButtonTitle: "확인",
          primaryButtonAction: .custom({
            if navigator?.currentPaths.last == "shop_detail" {
              navigator?.back(isAnimated: true)
            } else {
//              navigator?.backToLast(path: "", isAnimated: <#T##Bool#>)
            }
          })
        )
        
      case .failure:
        DialogManager.shared.showDialog(
          title: "요청 실패",
          message: "케이크 샵 요청에 실패하였어요..\n다시 시도해주세요.",
          primaryButtonTitle: "확인",
          primaryButtonAction: .cancel
        )
        
      case .serverError:
        DialogManager.shared.showDialog(.serverError())
        
      default:
        break
      }
      
      LoadingManager.shared.stopLoading()
    })
  }
  
  private func businessCertImageInputSection() -> some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(
        title: "사업자 등록증",
        description: "케이크 샵의 소유주임을 인증할 수있는 사업자 등록증을 첨부해주세요."
      )
      .padding(.horizontal, 24)
      
      HStack(spacing: 12) {
        if let selectedBusinessCertImage = viewModel.selectedBusinessCertImage {
          Image(uiImage: selectedBusinessCertImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .size(96)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .onTapGesture {
              showPhotosUI(for: .businessCert)
            }
        } else {
          Button {
            showPhotosUI(for: .businessCert)
          } label: {
            RoundedRectangle(cornerRadius: 14)
              .fill(Color.white)
              .size(96)
              .overlay {
                RoundedRectangle(cornerRadius: 14)
                  .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                  .foregroundStyle(DesignSystemAsset.gray30.swiftUIColor)
              }
              .overlay {
                DesignSystemAsset.cakePin.swiftUIImage
                  .resizable()
                  .size(60)
              }
          }
          .modifier(BouncyPressEffect())
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.vertical, 12)
      .padding(.horizontal, 24)
      .sheet(isPresented: $isBusinessCertPhotoPickerShown, content: {
        PhotoPicker(selectedImage: $viewModel.selectedBusinessCertImage)
          .ignoresSafeArea()
      })
    }
  }
  
  private func idCardImageInputSection() -> some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(
        title: "신분증",
        description: "사업자 등록증 정보와 일치하는 신분증 사진을 첨부해주세요."
      )
      .padding(.horizontal, 24)
      
      HStack(spacing: 12) {
        if let selectedIdCardImage = viewModel.selectedIdCardImage {
          Image(uiImage: selectedIdCardImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .size(96)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .onTapGesture {
              showPhotosUI(for: .idCard)
            }
        } else {
          Button {
            showPhotosUI(for: .idCard)
          } label: {
            RoundedRectangle(cornerRadius: 14)
              .fill(Color.white)
              .size(96)
              .overlay {
                RoundedRectangle(cornerRadius: 14)
                  .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                  .foregroundStyle(DesignSystemAsset.gray30.swiftUIColor)
              }
              .overlay {
                DesignSystemAsset.cakePin.swiftUIImage
                  .resizable()
                  .size(60)
              }
          }
          .modifier(BouncyPressEffect())
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.vertical, 12)
      .padding(.horizontal, 24)
      .sheet(isPresented: $isIdCardPhotoPickerShown, content: {
        PhotoPicker(selectedImage: $viewModel.selectedIdCardImage)
          .ignoresSafeArea()
      })
    }
  }
  
  private func contactInputSection() -> some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(
        title: "연락처",
        description: "심사 시 필요에 따라 비상 연락망을 통해서 연락드려요."
      )
      
      CKTextField(text: $viewModel.contact, placeholder: "연락처를 입력해 주세요")
    }
    .padding(.horizontal, 24)
  }
  
  private func additionalInputSection() -> some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(
        title: "추가 사항",
        description: "케이크크에서 알아야할 내용이 있다면 자유롭게 작성해 주세요."
      )
      
      CKTextField(text: $viewModel.additionalMessage, placeholder: "추가 내용을 입력해주세요", supportsMultiline: true)
    }
    .padding(.horizontal, 24)
  }
  
  // MARK: - Private Methods
  
  private func showPhotosUI(for photoPickerType: PhotoPickerType) {
    /// 라이브러리 접근 권한을 먼저 요청한 후 상황에 맞는 View를 띄워줍니다.
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { state in
      DispatchQueue.main.async {
        switch state {
        case .notDetermined:
          break
          
        case .restricted, .denied:
          DialogManager.shared.showDialog(
            title: "접근 권한 없음",
            message: "사진첩에 접근할 수 있는 권한이 없어요.\n설정으로 이동해서 사진접 접근 권한을 허용해주세요.",
            primaryButtonTitle: "설정으로 이동",
            primaryButtonAction: .custom({
              guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
              if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { _ in })
              }
            }),
            secondaryButtonTitle: "취소",
            secondaryButtonAction: .cancel)
          
        case .authorized, .limited:
          switch photoPickerType {
          case .businessCert:
            isBusinessCertPhotoPickerShown = true
          case .idCard:
            isIdCardPhotoPickerShown = true
          }
          
        @unknown default:
          break
        }
      }
    }
  }
}


// MARK: - Preview

import PreviewSupportUser

#Preview("Success") {
  let diContainer = DIContainer.shared.container
  diContainer.register(BusinessCertificationViewModel.self) { _ in
    let cakeShopOwnerVerificationUseCase = MockCakeShopOwnerVerificationUseCase()
    return BusinessCertificationViewModel(targetShopId: 0, cakeShopOwnerVerificationUseCase: cakeShopOwnerVerificationUseCase)
  }
  
  return BusinessCertificationView()
}

#Preview("Failure") {
  let diContainer = DIContainer.shared.container
  diContainer.register(BusinessCertificationViewModel.self) { _ in
    let cakeShopOwnerVerificationUseCase = MockCakeShopOwnerVerificationUseCase(scenario: .failure)
    return BusinessCertificationViewModel(targetShopId: 0, cakeShopOwnerVerificationUseCase: cakeShopOwnerVerificationUseCase)
  }
  
  return BusinessCertificationView()
}

#Preview("Server Error") {
  let diContainer = DIContainer.shared.container
  diContainer.register(BusinessCertificationViewModel.self) { _ in
    let cakeShopOwnerVerificationUseCase = MockCakeShopOwnerVerificationUseCase(scenario: .serverError)
    return BusinessCertificationViewModel(targetShopId: 0, cakeShopOwnerVerificationUseCase: cakeShopOwnerVerificationUseCase)
  }
  
  return BusinessCertificationView()
}
