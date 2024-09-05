//
//  LoadingManager.swift
//  CAKK
//
//  Created by 이승기 on 5/15/24.
//

import Combine
import UIKit

public final class LoadingManager {
  public static let shared = LoadingManager()
  
  private var loadingView: LoadingView?
  private var cancellables = Set<AnyCancellable>()
  
  private init() {
    setupBindings()
  }
  
  @Published var isLoading: Bool = false
  
  private func setupBindings() {
    $isLoading
      .receive(on: RunLoop.main)
      .sink { [weak self] isLoading in
        if isLoading {
          self?.showLoadingIndicator()
        } else {
          self?.hideLoadingIndicator()
        }
      }
      .store(in: &cancellables)
  }
  
  private func showLoadingIndicator() {
    if loadingView != nil { return }
    guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
          let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
      return
    }
    
    let loadingView = LoadingView(frame: .zero)
    
    window.addSubview(loadingView)
    loadingView.translatesAutoresizingMaskIntoConstraints = false
    loadingView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
    loadingView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
    loadingView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
    loadingView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
    
    loadingView.startAnimating()
    self.loadingView = loadingView
  }
  
  private func hideLoadingIndicator() {
    loadingView?.stopAnimating()
    loadingView = nil
  }
  
  public func startLoading() {
    isLoading = true
  }
  
  public func stopLoading() {
    isLoading = false
  }
}


import Lottie
import SnapKit

extension LoadingManager {
  class LoadingView: UIView {
    
    private var animationContainerView: UIVisualEffectView = {
      let visualEffect = UIBlurEffect(style: .regular)
      let view = UIVisualEffectView(effect: visualEffect)
      view.clipsToBounds = true
      view.layer.cornerRadius = 20
      return view
    }()
    
    private var animationView: LottieAnimationView = {
      let animationView = LottieAnimationView(name: "cake_running", bundle: DesignSystemResources.bundle)
      animationView.contentMode = .scaleAspectFit
      animationView.loopMode = .loop
      return animationView
    }()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }
    
    required init?(coder: NSCoder) {
      super.init(coder: coder)
      setupView()
    }
    
    private func setupView() {
      addSubview(animationContainerView)
      animationContainerView.snp.makeConstraints {
        $0.size.equalTo(92)
        $0.centerX.equalToSuperview()
        $0.centerY.equalToSuperview().offset(-32)
      }
      
      animationContainerView.contentView.addSubview(animationView)
      animationView.snp.makeConstraints {
        $0.size.equalTo(88)
        $0.centerY.equalToSuperview()
        $0.centerX.equalToSuperview().offset(4)
      }
    }
    
    func startAnimating() {
      animationView.play()
      
      backgroundColor = .clear
      animationContainerView.transform = .init(scaleX: 0, y: 0)
      
      UIView.animate(withDuration: 0.2) {
        self.backgroundColor = UIColor(white: 0, alpha: 0.36)
        self.animationContainerView.transform = .identity
      }
    }
    
    func stopAnimating() {
      UIView.animate(withDuration: 0.2, animations: {
        self.animationContainerView.transform = .init(scaleX: 0.1, y: 0.1)
        self.alpha = 0
      }, completion: { _ in
        self.animationView.stop()
        self.removeFromSuperview()  // 애니메이션이 완료된 후 view를 제거
      })
    }
  }
}


// MARK: - Preview

import SwiftUI

#Preview {
  VStack {
    Button("start loading") {
      LoadingManager.shared.startLoading()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        LoadingManager.shared.stopLoading()
      }
    }
  }
}
