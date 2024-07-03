//
//  EditCakeShopAddressView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import LocationService
import MapKit

import DomainCakeShop
import DIContainer
import Router

public struct EditCakeShopAddressView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: EditCakeShopAddressViewModel
  @EnvironmentObject private var router: Router
  
  @State private var reloadTrigger = false
  
  
  // MARK: - Initializers
  
  public init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(EditCakeShopAddressViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  // MARK: - Views
  
  public var body: some View {
    VStack(spacing: 0) {
      NavigationBar(leadingContent: {
        Button {
          if viewModel.hasChanges() {
            DialogManager.shared.showDialog(
              title: "저장",
              message: "저장되지 않은 내용이 있어요.\n내용을 저장하지 않고 나갈까요??",
              primaryButtonTitle: "네",
              primaryButtonAction: .custom({
                router.navigateBack()
              }),
              secondaryButtonTitle: "머무르기", secondaryButtonAction: .cancel)
          } else {
            router.navigateBack()
          }
        } label: {
          Image(systemName: "arrow.left")
            .font(.system(size: 20))
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        }
      }, centerContent: {
        Text("가게 위치")
          .font(.pretendard(size: 17, weight: .bold))
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      })
      
      VStack(spacing: 24) {
        CKTextField(text: $viewModel.cakeShopLocation.address, placeholder: "주소를 입력해주세요")
          .onSubmit {
            getCoordinate(from: viewModel.cakeShopLocation.address) { coordinate in
              if let coordinate = coordinate {
                viewModel.updateCoordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
                self.reloadTrigger.toggle()
              }
            }
          }
        
        ShopLocationMapView(shopName: "", latitude: viewModel.cakeShopLocation.latitude, longitude: viewModel.cakeShopLocation.longitude)
          .id(reloadTrigger)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      .padding(.horizontal, 24)
      .padding(.vertical, 16)
    }
    .toolbar(.hidden, for: .navigationBar)
    .overlay {
      VStack {
        VStack(spacing: 0) {
          LinearGradient(colors: [.clear, .white], startPoint: .top, endPoint: .bottom)
            .frame(height: 20)
          
          CKButtonLarge(title: "저장", fixedSize: .infinity, action: {
            DialogManager.shared.showDialog(
              title: "저장",
              message: "정말 이 상태로 저장할까요?",
              primaryButtonTitle: "확인",
              primaryButtonAction: .custom({
                viewModel.updateShopAddress()
              }),
              secondaryButtonTitle: "취소",
              secondaryButtonAction: .cancel)
          }, isLoading: .constant(viewModel.updatingState == .loading))
          .background(Color.white.ignoresSafeArea())
          .padding(.horizontal, 28)
          .padding(.bottom, 16)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    .onReceive(viewModel.$updatingState) { newState in
      switch newState {
      case .failure:
        DialogManager.shared.showDialog(
          title: "정보 업데이트 실패",
          message: "가게 주소 업데이트에 실패하였어요\n다시 시도해주세요",
          primaryButtonTitle: "확인",
          primaryButtonAction: .cancel)
        
      case .loading:
        LoadingManager.shared.startLoading()
        return
        
      case .success:
        DialogManager.shared.showDialog(
          title: "업데이트 성공",
          message: "가게 주소 업데이트에 성공하였어요",
          primaryButtonTitle: "확인",
          primaryButtonAction: .cancel)
        
      case .emptyAddress:
        DialogManager.shared.showDialog(
          title: "올바르지 않은 주소",
          message: "주소가 올바르지 않아요.\n다시 확인해주세요",
          primaryButtonTitle: "확인",
          primaryButtonAction: .cancel)
        
      default:
        break
      }
      
      LoadingManager.shared.stopLoading()
    }
  }
  
  private func getCoordinate(from address: String, completion: @escaping(CLLocationCoordinate2D?) -> ()) {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address) { placemarks, error in
      guard let placemarks = placemarks, let location = placemarks.first?.location else {
        completion(nil)
        return
      }
      completion(location.coordinate)
    }
  }
}


// MARK: - Preview

import PreviewSupportCakeShopAdmin

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(EditCakeShopAddressViewModel.self) { _ in
    let editShopAddressUseCase = MockEditShopAddressUseCase()
    let cakeShopLocation = CakeShopLocation(address: "",
                                            latitude: LocationService.defaultCoordinates.latitude,
                                            longitude: LocationService.defaultCoordinates.longitude)
    return EditCakeShopAddressViewModel(shopId: 0, cakeShopLocation: cakeShopLocation, editShopAddressUseCase: editShopAddressUseCase)
  }
  return EditCakeShopAddressView()
}
