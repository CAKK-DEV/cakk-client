//
//  TabStateManager.swift
//  CAKK
//
//  Created by 이승기 on 8/4/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import DesignSystem
import CommonUtil

final class TabStateManager: ObservableObject {
  
  // MARK: - Properties
  
  @Published var selectedTab: CAKKTabBar.Tab = .cakeShop
  private var cancellables = Set<AnyCancellable>()
  
  
  // MARK: - Initializers
  
  init() {
    listenForTabSelection()
  }
  
  
  // MARK: - Private Methods
  
  private func listenForTabSelection() {
    $selectedTab
      .sink { [weak self] newTab in
        guard let self else { return }
        
        if newTab == self.selectedTab {
          switch newTab {
          case .cakeShop:
            NotificationCenter.default.post(name: .doubleTapCakeShopTab, object: nil)
          case .search:
            NotificationCenter.default.post(name: .doubleTapSearchTab, object: nil)
          case .liked:
            NotificationCenter.default.post(name: .doubleTapLikedTab, object: nil)
          default:
            break
          }
        }
      }
      .store(in: &cancellables)
  }
}
