//
//  DialogManager.swift
//  DesignSystem
//
//  Created by 이승기 on 6/1/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import SwiftUI
import SnapKit

public final class DialogManager {
  
  // MARK: - Properties
  
  public static let shared = DialogManager()
  private var dialogView: UIView?
  private var dimmingView: UIView = {
    let view = UIView()
    view.backgroundColor = .black.withAlphaComponent(0.3)
    view.alpha = 0
    return view
  }()
  
  public enum DialogButtonAction: Equatable {
    case custom(() -> Void)
    case cancel
    
    public static func == (lhs: DialogButtonAction, rhs: DialogButtonAction) -> Bool {
      switch (lhs, rhs) {
      case (.cancel, .cancel):
        return true
      case (.custom, .custom):
        return true
      default:
        return false
      }
    }
  }
  
  
  // MARK: - Initializers
  
  private init() { 
    setupDimmingViewGesture()
  }
  
  
  // MARK: - Public Methods
  
  public func showDialog(title: String,
                         message: String = "",
                         primaryButtonTitle: String,
                         primaryButtonAction: DialogButtonAction,
                         secondaryButtonTitle: String? = nil,
                         secondaryButtonAction: DialogButtonAction? = nil) {
    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
    
    let primaryButtonActionClosure = createButtonActionClosure(from: primaryButtonAction)!
    let secondaryButtonActionClosure = createButtonActionClosure(from: secondaryButtonAction)
    
    let dialogView = DialogView(
      title: title,
      message: message,
      primaryButtonTitle: primaryButtonTitle,
      primaryButtonAction: primaryButtonActionClosure,
      secondaryButtonTitle: secondaryButtonAction == .cancel ? "취소" :  secondaryButtonTitle,
      secondaryButtonAction: secondaryButtonActionClosure)
    dialogView.alpha = 0
    dialogView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    self.dialogView = dialogView
    
    window.addSubview(dimmingView)
    window.addSubview(dialogView)
    
    dimmingView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    dialogView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.equalTo(320)
    }
    
    UIView.animate(withDuration: 0.4,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 0.8) {
      self.dimmingView.alpha = 1
      dialogView.alpha = 1
      dialogView.transform = .identity
    }
  }
  
  public func hideDialog() {
    UIView.animate(withDuration: 0.4,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 0.8) {
      self.dialogView?.alpha = 0
      self.dialogView?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
      self.dimmingView.alpha = 0
    } completion: { _ in
      self.dialogView?.removeFromSuperview()
      self.dimmingView.removeFromSuperview()
    }
  }
  
  
  // MARK: - Private Method
  
  private func createButtonActionClosure(from action: DialogButtonAction?) -> (() -> Void)? {
    guard let action = action else { return nil }
    
    switch action {
    case .custom(let customAction):
      return { [weak self] in
        customAction()
        self?.hideDialog()
      }
    case .cancel:
      return { [weak self] in
        self?.hideDialog()
      }
    }
  }
  
  private func setupDimmingViewGesture() {
     let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDimmingViewTap))
     dimmingView.addGestureRecognizer(tapGesture)
   }
   
   @objc private func handleDimmingViewTap() {
     guard let dialogView = dialogView else { return }
     
     UINotificationFeedbackGenerator().notificationOccurred(.warning)
     
     UIView.animate(withDuration: 0.1, animations: {
       dialogView.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
     }) { _ in
       UIView.animate(withDuration: 0.5) {
         dialogView.transform = .identity
       }
     }
   }
}


// MARK: - DialogView

private extension DialogManager {
  
  class DialogView: UIView {
    
    private let title: String
    private let message: String
    private let primaryButtonTitle: String
    private let primaryButtonAction: () -> Void
    private let secondaryButtonTitle: String?
    private let secondaryButtonAction: (() -> Void)?
    
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let primaryButton = UIButton()
    private var secondaryButton: UIButton?
    
    private let buttonStackView = UIStackView()
    
    init(title: String,
         message: String = "",
         primaryButtonTitle: String,
         primaryButtonAction: @escaping () -> Void,
         secondaryButtonTitle: String? = nil,
         secondaryButtonAction: (() -> Void)? = nil) {
      self.title = title
      self.message = message
      self.primaryButtonTitle = primaryButtonTitle
      self.primaryButtonAction = primaryButtonAction
      self.secondaryButtonTitle = secondaryButtonTitle
      self.secondaryButtonAction = secondaryButtonAction
      
      super.init(frame: .zero)
      
      setupViews()
      setupConstraints()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
      backgroundColor = .white
      layer.cornerRadius = 24
      layer.cornerCurve = .continuous
      
      titleLabel.textColor = DesignSystemAsset.black.color
      titleLabel.font = .init(font: DesignSystemFontFamily.Pretendard.bold, size: 24)
      titleLabel.text = title
      titleLabel.numberOfLines = 1
      addSubview(titleLabel)
      
      messageLabel.textColor = DesignSystemAsset.gray40.color
      messageLabel.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 15)
      messageLabel.text = message
      messageLabel.numberOfLines = 4
      addSubview(messageLabel)
      
      if let secondaryButtonTitle,
         let secondaryButtonAction {
        let secondaryButton = UIButton()
        self.secondaryButton = secondaryButton
        secondaryButton.setTitle(secondaryButtonTitle, for: .normal)
        secondaryButton.setTitleColor(DesignSystemAsset.gray50.color, for: .normal)
        secondaryButton.setTitleColor(DesignSystemAsset.gray50.color.withAlphaComponent(0.3), for: .highlighted)
        secondaryButton.backgroundColor = .white
        secondaryButton.titleLabel?.font = .init(font: DesignSystemFontFamily.Pretendard.bold, size: 15)
        secondaryButton.layer.cornerRadius = 14
        secondaryButton.addAction(.init(handler: { _ in
          secondaryButtonAction()
        }), for: .touchUpInside)
        buttonStackView.addArrangedSubview(secondaryButton)
      }
      
      primaryButton.setTitle(primaryButtonTitle, for: .normal)
      primaryButton.setTitleColor(.white, for: .normal)
      primaryButton.setTitleColor(.white.withAlphaComponent(0.3), for: .highlighted)
      primaryButton.backgroundColor = DesignSystemAsset.black.color
      primaryButton.titleLabel?.font = .init(font: DesignSystemFontFamily.Pretendard.bold, size: 15)
      primaryButton.layer.cornerRadius = 14
      primaryButton.layer.cornerCurve = .continuous
      primaryButton.addAction(.init(handler: { [weak self] _ in
        self?.primaryButtonAction()
      }), for: .touchUpInside)
      buttonStackView.addArrangedSubview(primaryButton)
      
      buttonStackView.distribution = .fillEqually
      addSubview(buttonStackView)
    }
    
    private func setupConstraints() {
      titleLabel.snp.makeConstraints {
        $0.top.equalToSuperview().inset(32)
        $0.horizontalEdges.equalToSuperview().inset(24)
      }
      
      messageLabel.snp.makeConstraints {
        $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        $0.horizontalEdges.equalToSuperview().inset(24)
      }
      
      buttonStackView.snp.makeConstraints {
        $0.top.equalTo(messageLabel.snp.bottom).offset(28)
        $0.height.equalTo(52)
        $0.horizontalEdges.equalToSuperview().inset(12)
        $0.bottom.equalToSuperview().inset(16)
      }
    }
  }
}


// MARK: - Preview

#Preview {
  VStack(spacing: 12) {
    Button("Show dialog") {
      DialogManager.shared.showDialog(
        title: "Title",
        message: "mesasge\nmessage\nmessage\nmessage\nmessage",
        primaryButtonTitle: "Title",
        primaryButtonAction: .cancel,
        secondaryButtonTitle: "title",
        secondaryButtonAction: .cancel
      )
    }
    
    Button("Show dialog no message") {
      DialogManager.shared.showDialog(
        title: "Title",
        primaryButtonTitle: "Title",
        primaryButtonAction: .cancel,
        secondaryButtonTitle: "title",
        secondaryButtonAction: .cancel
      )
    }
    
    Button("Show dialog no secondary") {
      DialogManager.shared.showDialog(
        title: "Title",
        message: "message",
        primaryButtonTitle: "Title",
        primaryButtonAction: .cancel
      )
    }
    
    Button("Show action dialog") {
      DialogManager.shared.showDialog(
        title: "Title",
        message: "mesasge\nmessage\nmessage\nmessage\nmessage",
        primaryButtonTitle: "Title",
        primaryButtonAction: .custom({
          print("activated")
        }),
        secondaryButtonTitle: "title",
        secondaryButtonAction: .cancel
      )
    }
  }
}
