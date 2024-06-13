//
//  Dialog+Templates.swift
//  DesignSystem
//
//  Created by 이승기 on 6/12/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public extension DialogManager {
  
  enum Template {
    case serverError(completion: (() -> Void)?)
    case unknownError(completion: (() -> Void)?)
  }
  
  func showDialog(_ template: Template) {
    switch template {
    case .serverError(let completion):
      showDialog(title: "서버 에러",
                 message: "서버 에러가 발생했어요.\n나중에 다시 시도해 주세요.",
                 primaryButtonTitle: "확인",
                 primaryButtonAction: .custom({
        completion?()
      }))
    case .unknownError(let completion):
      showDialog(title: "알 수 없는 오류",
                 message: "알 수 없는 오류가 발생했어요.\n나중에 다시 시도해 주세요.",
                 primaryButtonTitle: "확인",
                 primaryButtonAction: .custom({
        completion?()
      }))
    }
  }
}
