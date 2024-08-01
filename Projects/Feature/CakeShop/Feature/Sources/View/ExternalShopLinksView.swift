//
//  ExternalShopLinksView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DomainCakeShop
import AdManager

struct ExternalShopLinksView: View {
  
  // MARK: - Properties
  
  private let externalShopLinks: [ExternalShopLink]
  private let emptyLinkButtonAction: (() -> Void)?
  
  @AppStorage("external_link_click_count") var externalLinkClickCount = 0
  @Environment(\.scenePhase) private var scenePhase
  private let interstitialAdManager = InterstitialAdsManager()
  
  
  // MARK: - Initializers
  
  init(
    externalShopLinks: [ExternalShopLink],
    emptyLinkButtonAction: (() -> Void)? = nil
  ) {
    self.externalShopLinks = externalShopLinks
    self.emptyLinkButtonAction = emptyLinkButtonAction
  }
  
  
  // MARK: - Views
  
  var body: some View {
    HStack(spacing: 8) {
      ForEach(ExternalShopLink.LinkType.allCases, id: \.self) { linkType in
        if let externalShopLink = externalShopLinks.filter({ $0.linkType == linkType }).first {
          ExternalShopLinkButton(linkType: externalShopLink.linkType,
                                 urlString: externalShopLink.linkPath)
        } else {
          ExternalShopLinkButton(linkType: linkType, emptyLinkButtonAction: emptyLinkButtonAction)
        }
      }
    }
    .onChange(of: scenePhase) { newPhase in
      switch newPhase {
      case .active:
        showInterstitialLinkIfNeeded()
      default:
        break
      }
    }
  }
  
  
  // MARK: - Private Methods
  
  private func showInterstitialLinkIfNeeded() {
    /// 전면 광고는 외부 링크 클릭 3번에 한 번씩 표시
    if externalLinkClickCount % 3 == 0 {
      interstitialAdManager.displayInterstitialAd(adUnit: .externalLinkAd)
    }
  }
}


// MARK: - Preview

#Preview {
  ExternalShopLinksView(externalShopLinks: [
    .init(linkType: .instagram, linkPath: "https://www.google.com"),
    .init(linkType: .web, linkPath: "https://www.google.com")
  ])
}
