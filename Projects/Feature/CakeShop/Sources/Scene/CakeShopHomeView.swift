//
//  CakeShopHomeView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/2/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

struct CakeShopHomeView: View {
  var body: some View {
    VStack(spacing: 0) {
      MainNavigationView()
      
      ScrollView {
        VStack(spacing: 44) {
          CakeCategorySection()
        }
        .padding(.vertical, 16)
      }
    }
  }
}

#Preview {
  CakeShopHomeView()
}
