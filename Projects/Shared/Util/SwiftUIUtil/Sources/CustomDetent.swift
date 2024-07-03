//
//  CustomDetent.swift
//  SwiftUIUtil
//
//  Created by 이승기 on 6/7/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import SwiftUI

/// Sheet의 detent가 large일 때 parentView가 뒤로 밀려나는 효과를 제거하는
/// 커스텀 프레젠테이션 디텐트입니다.
///
/// Usage:
/// ```
/// .presentationDetents([.custom(CustomDetent.self)])
/// ```
public struct CustomDetent: CustomPresentationDetent {
    
    /// 커스텀 디텐트의 높이를 결정합니다.
    ///
    /// - Parameter context: 디텐트가 사용되는 컨텍스트입니다.
    /// - Returns: 최대 디텐트 값에서 1을 뺀 커스텀 디텐트의 높이입니다.
    public static func height(in context: Context) -> CGFloat? {
        return context.maxDetentValue - 1
    }
}
