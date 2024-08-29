//
//  ShareCakeShopView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 8/28/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem
import Kingfisher

import KakaoSDKCommon
import KakaoSDKTemplate
import KakaoSDKShare

import Logger
import AnalyticsService

public struct ShareCakeShopView: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var viewModel: CakeShopDetailViewModel
  
  @StateObject private var motionData = MotionObserver()
  @State var gradientBackground = AnimatedGradientBackground(
    backgroundColor: Color(hex: "FEB0CD"),
    gradientColors: [
      Color(hex: "FE85A5"),
      Color(hex: "FE85A5"),
      Color(hex: "FED6C3")
    ])
  
  @State private var firstBackgroundImageLoaded = false
  @State private var secondBackgroundImageLoaded = false
  @State private var thirdBackgroundImageLoaded = false
  @State private var fourthBackgroundImageLoaded = false
  
  @State private var loadingKakaoShare = false
  
  @State private var successToCopyDeepLink = false
  @State private var clipboardScale: CGFloat = 1
  
  private var analytics: AnalyticsService?
  
  
  // MARK: - Initializers
  
  public init() { 
    let container = DIContainer.shared.container
    self.analytics = container.resolve(AnalyticsService.self)
  }
  
  // MARK: - Views
  
  public var body: some View {
    ZStack {
      if let thumbnailImageUrlString = viewModel.cakeShopDetail?.thumbnailImageUrl,
         let thumbnailImageUrl = URL(string: thumbnailImageUrlString) {
        Color.clear.overlay { /// 이유는 모르겠지만 이렇게 해주지 않으면 scaleToFill() 에 의해서 ㅠackgroundImagesView가 안 보임
          KFImage(thumbnailImageUrl)
            .resizable()
            .scaledToFill()
            .blur(radius: 40)
        }
        .ignoresSafeArea()
      } else {
        gradientBackground
      }
      
      backgroundImagesView()
      
      VStack(spacing: -64) {
        Circle()
          .fill(Color.white)
          .size(128)
          .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
          .zIndex(1)
          .overlay {
            if let thumbnailImageUrlString = viewModel.cakeShopDetail?.thumbnailImageUrl,
               let thumbnailImageUrl = URL(string: thumbnailImageUrlString) {
              KFImage(thumbnailImageUrl)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .padding(3)
            }
          }
        
        RoundedRectangle(cornerRadius: 32)
          .fill(Color.white)
          .frame(width: 320, height: 185)
          .overlay {
            VStack(spacing: 8) {
              if let cakeShopDetail = viewModel.cakeShopDetail {
                Text(cakeShopDetail.shopName)
                  .font(.pretendard(size: 28, weight: .bold))
                  .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
                
                Text(cakeShopDetail.shopBio)
                  .font(.pretendard(size: 15, weight: .medium))
                  .foregroundStyle(DesignSystemAsset.gray40.swiftUIColor)
                  .lineLimit(1)
                  .padding(.horizontal, 16)
              } else {
                ProgressView()
              }
            }
            .padding(.top, 40)
          }
      }
      .padding(.bottom, 32)
      .offset(motionData.movingOffset)
      .onFirstAppear {
        motionData.fetchMotionData(duration: 15)
      }
      
      VStack {
        HStack {
          Button {
            copyLinkOnClipboard()
          } label: {
            RoundedRectangle(cornerRadius: 20)
              .fill(Color.white.opacity(0.3))
              .frame(width: 76, height: 64)
              .overlay {
                Image(systemName: successToCopyDeepLink ? "checkmark" : "link")
                  .font(.system(size: 24))
                  .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
                  .scaleEffect(clipboardScale)
                  .animation(.smooth(duration: 0.2), value: clipboardScale)
              }
              .overlay {
                RoundedRectangle(cornerRadius: 20)
                  .stroke(DesignSystemAsset.gray40.swiftUIColor.opacity(0.3), lineWidth: 1)
              }
          }
          .modifier(BouncyPressEffect())
          
          CKButtonLarge(title: "카카오톡 공유", action: {
            loadingKakaoShare = true
            shareWithKakao()
          }, isLoading: .constant(loadingKakaoShare))
        }
        .padding(.bottom, 28)
      }
      .frame(maxHeight: .infinity, alignment: .bottom)
    }
    .onAppear {
      analytics?.logEngagement(view: self)
    }
  }
  
  @ViewBuilder
  private func backgroundImagesView() -> some View {
    ZStack {
      if let firstCakeImageUrlString = viewModel.cakeImages[safe: 0]?.imageUrl {
        GeometryReader { proxy in
          Color.clear
            .frame(width: 200, height: 200)
            .overlay {
              KFImage(URL(string: firstCakeImageUrlString))
                .onSuccess { _ in
                  firstBackgroundImageLoaded = true
                }
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .rotationEffect(.degrees(firstBackgroundImageLoaded ? 37 : 0))
            .offset(x: firstBackgroundImageLoaded ? -100 : -300, 
                    y: firstBackgroundImageLoaded ? 60 : -100)
            .opacity(firstBackgroundImageLoaded ? 0.6 : 0)
            .animation(.snappy, value: firstBackgroundImageLoaded)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      
      if let secondCakeImageUrlString = viewModel.cakeImages[safe: 1]?.imageUrl {
        GeometryReader { proxy in
          Color.clear
            .frame(width: 200, height: 200)
            .overlay {
              KFImage(URL(string: secondCakeImageUrlString))
                .onSuccess { _ in
                  secondBackgroundImageLoaded = true
                }
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .rotationEffect(.degrees(-36))
            .offset(x: secondBackgroundImageLoaded ?  proxy.size.width - 100 :proxy.size.width,
                    y: secondBackgroundImageLoaded ? 0 : -100)
            .opacity(secondBackgroundImageLoaded ? 0.6 : 0)
            .animation(.snappy, value: secondBackgroundImageLoaded)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      
      if let thirdCakeImageUrlString = viewModel.cakeImages[safe: 2]?.imageUrl {
        GeometryReader { proxy in
          Color.clear
            .frame(width: 200, height: 200)
            .overlay {
              KFImage(URL(string: thirdCakeImageUrlString))
                .onSuccess { _ in
                  thirdBackgroundImageLoaded = true
                }
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .rotationEffect(.degrees(22))
            .offset(x: thirdBackgroundImageLoaded ? -140 : -300 ,
                    y: thirdBackgroundImageLoaded ? proxy.size.height - 250 : proxy.size.height - 250)
            .opacity(thirdBackgroundImageLoaded ? 0.6 : 0)
            .animation(.snappy, value: thirdBackgroundImageLoaded)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      
      if let fourthCakeImageUrlString = viewModel.cakeImages[safe: 3]?.imageUrl {
        GeometryReader { proxy in
          Color.clear
            .frame(width: 200, height: 200)
            .overlay {
              KFImage(URL(string: fourthCakeImageUrlString))
                .onSuccess { _ in
                  fourthBackgroundImageLoaded = true
                }
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .opacity(0.6)
            }
            .rotationEffect(.degrees(-18))
            .offset(x: fourthBackgroundImageLoaded ? proxy.size.width - 100 : proxy.size.width,
                    y: fourthBackgroundImageLoaded ? proxy.size.height - 200 : proxy.size.height)
            .opacity(fourthBackgroundImageLoaded ? 0.6 : 0)
            .animation(.snappy, value: fourthBackgroundImageLoaded)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
  
  
  // MARK: - Private Methods
  
  private func copyLinkOnClipboard() {
    guard let shopDetail = viewModel.cakeShopDetail else { return }
    let message = "\(shopDetail.shopName)\n\(shopDetail.shopBio)\n\(makeDeepLink())"
    UIPasteboard.general.string = message
    clipboardScale = 0
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
      successToCopyDeepLink = true
      clipboardScale = 1
    }
    
    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    
    analytics?.logEvent(name: "share", parameters: ["shopId": viewModel.shopId, "method": "클립보드"])
  }
  
  private func shareWithKakao() {
    guard let shopDetail = viewModel.cakeShopDetail else { return }
    
    let link = Link(iosExecutionParams: ["shopId": "\(viewModel.shopId)"])
    let showViaAppButton = Button(title: "앱으로 보기", link: link)
    let imageUrl = URL(string: viewModel.cakeImages.randomElement()?.imageUrl ?? "")
    
    let content = Content(title: shopDetail.shopName,
                          imageUrl: imageUrl,
                          description: shopDetail.shopBio,
                          link: link)
    let feedTemplate = FeedTemplate(content: content, buttons: [showViaAppButton])
    
    if let feedTemplateJsonData = (try? SdkJSONEncoder.custom.encode(feedTemplate)) {
      if let templateJsonObject = SdkUtils.toJsonObject(feedTemplateJsonData) {
        ShareApi.shared.shareDefault(templateObject: templateJsonObject) { (sharingResult, error) in
          loadingKakaoShare = false
          
          if let error = error {
            Loggers.featureCakeShop.log("카카오톡 공유 실패: \(error.localizedDescription)", category: .network)
          } else {
            guard let sharingResult = sharingResult else { return }
            UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
            analytics?.logEvent(name: "share", parameters: ["shopId": viewModel.shopId, "method": "카카오"])
          }
        }
      }
    }
  }
  
  private func makeDeepLink() -> String {
    return "cakk://shopid?id=\(viewModel.shopId)"
  }
}


// MARK: - Preview

import DIContainer
import PreviewSupportCakeShop
import PreviewSupportUser
import PreviewSupportSearch

#Preview {
  struct PreviewContent: View {
    @StateObject private var viewModel: CakeShopDetailViewModel
    init() {
      let cakeShopDetailUseCase = MockCakeShopDetailUseCase()
      let cakeImagesByShopIdUseCase = MockCakeImagesByShopIdUseCase()
      let cakeShopAdditionalInfoUseCase = MockCakeShopAdditionalInfoUseCase()
      let likeCakeShopUseCase = MockLikeCakeShopUseCase()
      let cakeShopOwnedStateUseCase = MockCakeShopOwnedStateUseCase()
      let myShopIdUseCase = MockMyShopIdUseCase()
      
      let viewModel = CakeShopDetailViewModel(
        shopId: 0,
        cakeShopDetailUseCase: cakeShopDetailUseCase,
        cakeImagesByShopIdUseCase: cakeImagesByShopIdUseCase,
        cakeShopAdditionalInfoUseCase: cakeShopAdditionalInfoUseCase,
        likeCakeShopUseCase: likeCakeShopUseCase,
        cakeShopOwnedStateUseCase: cakeShopOwnedStateUseCase,
        myShopIdUseCase: myShopIdUseCase)
      
      _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
      ShareCakeShopView()
        .environmentObject(viewModel)
        .onAppear {
          viewModel.fetchCakeShopDetail()
          viewModel.fetchCakeImages()
        }
    }
  }
  
  return PreviewContent()
}
