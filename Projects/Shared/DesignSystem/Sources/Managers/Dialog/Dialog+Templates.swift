//
//  Dialog+Templates.swift
//  DesignSystem
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import UIKit

public extension DialogManager {
  
  enum Template {
    case serverError(completion: (() -> Void)? = nil)
    case unknownError(completion: (() -> Void)? = nil)
    case pleaseWait(completion: (() -> Void)? = nil)
    case loginRequired(completion: (() -> Void)? = nil)
    case locationPermissionDenied(completion: (() -> Void)? = nil)
  }
  
  func showDialog(_ template: Template) {
    switch template {
    case .serverError(let completion):
      showDialog(
        title: "서버 에러",
        message: "서버 에러가 발생했어요.\n나중에 다시 시도해 주세요.",
        primaryButtonTitle: "확인",
        primaryButtonAction: .custom({
          completion?()
        }))
    case .unknownError(let completion):
      showDialog(
        title: "알 수 없는 오류",
        message: "알 수 없는 오류가 발생했어요.\n나중에 다시 시도해 주세요.",
        primaryButtonTitle: "확인",
        primaryButtonAction: .custom({
          completion?()
        }))
    case .pleaseWait(let completion):
      showDialog(
        title: "불러오는 중",
        message: "잠시만 기다려주세요.",
        primaryButtonTitle: "확인",
        primaryButtonAction: .custom({
          completion?()
        }))
      
    case .loginRequired(let completion):
      showDialog(
        title: "로그인 필요",
        message: "로그인이 필요한 기능이에요.\n로그인하여 더 많은 기능을 누려보세요!",
        primaryButtonTitle: "로그인",
        primaryButtonAction: .custom({
          completion?()
        }),
        secondaryButtonTitle: "취소",
        secondaryButtonAction: .cancel)
      
    case .locationPermissionDenied(let completion):
      showDialog(
        title: "위치권한 필요",
        message: "지도 기반으로 케이크샵을 검색하려면 위치권한이 필요해요!",
        primaryButtonTitle: "설정으로 이동",
        primaryButtonAction: .custom({
          guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
          if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { _ in })
          }
          completion?()
        }), secondaryButtonTitle: "취소",
        secondaryButtonAction: .custom({
          completion?()
        }))
    }
  }
}
