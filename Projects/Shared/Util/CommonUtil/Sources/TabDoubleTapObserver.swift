//
//  TabDoubleTapObserver.swift
//  FeatureCakeShop
//
//  Created by 이승기 on 8/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public final class TabDoubleTapObserver: ObservableObject {
  
  // MARK: - Properties
  
  private let notificationName: Notification.Name
  @Published public var doubleTabActivated = false
  
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  public init(_ name: Notification.Name) {
    self.notificationName = name
    bind()
  }
  
  
  // MARK: - Private Methods
  
  private func bind() {
    NotificationCenter.default.publisher(for: notificationName)
      .sink { [weak self] notification in
        self?.doubleTabActivated.toggle()
      }
      .store(in: &cancellables)
  }
}


// MARK: - Notification Names

public extension Notification.Name {
  static let doubleTapCakeShopTab = Notification.Name("double_tap_cakeshop_tab")
  static let doubleTapSearchTab = Notification.Name("double_tap_search_tab")
  static let doubleTapLikedTab = Notification.Name("double_tap_liked_tab")
}
