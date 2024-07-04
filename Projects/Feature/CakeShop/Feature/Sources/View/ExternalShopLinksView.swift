//
//  ExternalShopLinksView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

import DomainCakeShop

struct ExternalShopLinksView: View {
  
  // MARK: - Properties
  
  private let externalShopLinks: [ExternalShopLink]
  private let emptyLinkButtonAction: (() -> Void)?
  
  
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
  }
}


// MARK: - Preview

#Preview {
  ExternalShopLinksView(externalShopLinks: [
    .init(linkType: .instagram, linkPath: "https://www.google.com"),
    .init(linkType: .web, linkPath: "https://www.google.com")
  ])
}
