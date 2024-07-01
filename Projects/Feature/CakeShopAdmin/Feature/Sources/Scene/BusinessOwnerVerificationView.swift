//
//  BusinessOwnerVerificationView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

struct BusinessOwnerVerificationView: View {
  
  // MARK: - Properties
  
  let message: String
  
  // MARK: - Initializers
  
  // MARK: - Views
  
  var body: some View {
    Text("Details for \(message)")
      .toolbar {
        Button(action: {}) {
          Image(systemName: "square.and.arrow.up")
        }
      }
  }
}


// MARK: - Preview

#Preview {
  BusinessOwnerVerificationView(message: "empty")
}
