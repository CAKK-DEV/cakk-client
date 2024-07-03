//
//  WorkingDayTime+Format.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import DomainCakeShop

extension WorkingDayWithTime {
  func makeBusinessHourFormattedString() -> String? {
    if let startTime = startTime.toFormattedTimeString(),
       let endTime = endTime.toFormattedTimeString() {
      return "\(startTime) ~ \(endTime)"
    } else {
      return nil
    }
  }
}

private extension String {
  func toFormattedTimeString() -> String? {
    // 정규 표현식 패턴: "00:00:00" 형식의 문자열을 검사
    let pattern = "^\\d{2}:\\d{2}:\\d{2}$"
    let regex = try! NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: self.utf16.count)
    
    // 문자열이 정규 표현식 패턴과 일치하는지 확인
    if regex.firstMatch(in: self, options: [], range: range) != nil {
      // "00:00" 형식으로 변환
      let components = self.split(separator: ":")
      return "\(components[0]):\(components[1])"
    } else {
      return nil // 올바르지 않은 형식
    }
  }
}
