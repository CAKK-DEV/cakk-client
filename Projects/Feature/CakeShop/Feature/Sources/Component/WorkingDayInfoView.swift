//
//  WorkingDayInfoView.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem

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
          .font(.pretendard(size: 15, weight: .medium))
          .foregroundStyle(workingDays.contains(workingDay)
                           ? Color(hex: "FF5CBE")
                           : DesignSystemAsset.gray40.swiftUIColor )
      }
    }
  }
}

#Preview {
  WorkingDayInfoView(workingDays: [.tue, .wed, .fri, .sat, .sun])
}

extension WorkingDay {
  var displayName: String {
    switch self {
    case .mon:
      "월"
    case .tue:
      "화"
    case .wed:
      "수"
    case .thu:
      "목"
    case .fri:
      "금"
    case .sat:
      "토"
    case .sun:
      "일"
    }
  }
}
