//
//  WorkingDayInfoView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

import CommonDomain
import DomainCakeShop

struct WorkingDayInfoView: View {
  
  // MARK: - Properties
  
  private var workingDays: [WorkingDay]
  
  // MARK: - Initializers
  
  init(workingDays: [WorkingDay]) {
    self.workingDays = workingDays
  }
  
  
  // MARK: - Views
  
  var body: some View {
    HStack(spacing: 6) {
      ForEach(WorkingDay.allCases, id: \.self) { workingDay in
        Text(workingDay.displayName)
          .font(.pretendard(size: 13, weight: .medium))
          .foregroundStyle(workingDays.contains(workingDay)
                           ? DesignSystemAsset.brandcolor2.swiftUIColor
                           : DesignSystemAsset.gray40.swiftUIColor )
      }
    }
  }
}


// MARK: - Preview

#Preview {
  WorkingDayInfoView(workingDays: [.tue, .wed, .fri, .sat, .sun])
}
