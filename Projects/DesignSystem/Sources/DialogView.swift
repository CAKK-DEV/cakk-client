//
//  DialogView.swift
//  DesignSystem
//
//  Created by 이승기 on 6/1/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

struct DialogView: View {
  var body: some View {
    VStack {
      VStack(spacing: 12) {
        Text("Title")
          .font(.pretendard(size: 24, weight: .bold))
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
          .frame(maxWidth: .infinity, alignment: .leading)

        Text("message")
          .font(.pretendard(size: 15, weight: .medium))
          .foregroundStyle(DesignSystemAsset.gray40.swiftUIColor)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.vertical, 16)
      .padding(.horizontal, 8)
      
      HStack(spacing: 8) {
        Button {
          
        } label: {
          
        }
        
        Button {
          
        } label: {
          
        }
      }
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 16)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 24))
    .frame(maxWidth: 320)
  }
}

#Preview {
  ZStack {
    Color.gray.opacity(0.2)
      .ignoresSafeArea()
    
    DialogView()
  }
}
