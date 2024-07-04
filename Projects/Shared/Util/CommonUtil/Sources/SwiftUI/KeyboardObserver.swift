//
//  KeyboardObserver.swift
//  CommonUtil
//
//  Created by 이승기 on 6/21/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import Combine

public final class KeyboardObserver: ObservableObject {
  @Published public var isKeyboardVisible: Bool = false
  private var cancellables = Set<AnyCancellable>()
  
  public init() {
    NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
      .sink { [weak self] _ in self?.isKeyboardVisible = true }
      .store(in: &cancellables)
    
    NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
      .sink { [weak self] _ in self?.isKeyboardVisible = false }
      .store(in: &cancellables)
  }
}
