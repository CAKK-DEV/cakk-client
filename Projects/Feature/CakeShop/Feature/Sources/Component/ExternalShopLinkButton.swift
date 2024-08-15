//
//  ExternalShopLinkButton.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import DomainCakeShop
import AdManager

struct ExternalShopLinkButton: View {
  
  // MARK: - Properties
  
  private let linkType: ExternalShopLink.LinkType
  private let urlString: String?
  private let emptyLinkButtonAction: (() -> Void)?
  
  @AppStorage("external_link_click_count") var externalLinkClickCount = 0
  private let interstitialAdManager = InterstitialAdsManager()
  
  
  // MARK: - Initializers
  
  init(
    linkType: ExternalShopLink.LinkType,
    urlString: String? = nil,
    emptyLinkButtonAction: (() -> Void)? = nil
  ) {
    self.linkType = linkType
    self.urlString = urlString
    self.emptyLinkButtonAction = emptyLinkButtonAction
  }
  
  
  // MARK: - Views
  
  var body: some View {
    Group {
      if let urlString,
         let url = URL(string: urlString) {
        Button {
          increaseExternalLinkClickCount()
          UIApplication.shared.open(url)
        } label: {
          Text(linkType.existsDisplayName)
            .font(.pretendard(size: 13, weight: .medium))
            .padding(.horizontal, 22)
            .frame(height: 36)
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
            .background(DesignSystemAsset.gray10.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .modifier(BouncyPressEffect())
      } else {
        Button {
          emptyLinkButtonAction?()
        } label: {
          Text(linkType.noExistsDisplayName)
            .font(.pretendard(size: 13, weight: .medium))
            .padding(.horizontal, 22)
            .frame(height: 36)
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
            .overlay {
              RoundedRectangle(cornerRadius: 14)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                .foregroundStyle(DesignSystemAsset.gray40.swiftUIColor)
            }
        }
        .modifier(BouncyPressEffect())
      }
    }
  }
  
  
  // MARK: - Private Methods
  
  private func increaseExternalLinkClickCount() {
    externalLinkClickCount += 1
    
    if externalLinkClickCount % 3 == 0 {
      interstitialAdManager.loadInterstitialAd(adUnit: .externalLinkAd)
    }
    print(externalLinkClickCount)
  }
}


// MARK: - Preview

#Preview {
  VStack {
    ForEach(ExternalShopLink.LinkType.allCases, id: \.self) { linkType in
      HStack {
        ExternalShopLinkButton(linkType: linkType, urlString: "https://www.google.com")
        ExternalShopLinkButton(linkType: linkType)
      }
    }
  }
}

