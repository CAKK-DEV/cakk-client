//
//  UINavigationController+SwipeToBack.swift
//  CommonUtil
//
//  Created by 이승기 on 6/3/24.
//  Copyright © 2024 cakk. All rights reserved.
//
//
//import SwiftUI
//
//extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
//  open override func viewDidLoad() {
//    super.viewDidLoad()
//    interactivePopGestureRecognizer?.delegate = self
//  }
//  
//  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//    return viewControllers.count > 1
//  }
//}
