//
//  ZoomGesture.swift
//  CommonUtil
//
//  Created by 이승기 on 6/13/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI

public extension View {
  func getRect() -> CGRect {
    return UIScreen.main.bounds
  }
}

public extension View {
  func addPinchZoom() -> some View {
    return PinchZoomContext {
      self
    }
  }
}

public struct PinchZoomContext<Content: View>: View {
  var content: Content
  
  public init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content()
  }
  
  public var body: some View {
    content
  }
}

public struct ZoomGesture: UIViewRepresentable {
  
  var size: CGSize
  
  @Binding var scale: CGFloat
  @Binding var offset: CGPoint
  @Binding var scalePosition: CGPoint
  
  public init(
    size: CGSize,
    scale: Binding<CGFloat>,
    offset: Binding<CGPoint>,
    scalePosition: Binding<CGPoint>
  ) {
    self.size = size
    _scale = scale
    _offset = offset
    _scalePosition = scalePosition
  }
  
  public func makeUIView(context: Context) -> some UIView {
    let view = UIView()
    view.backgroundColor = .clear
    
    let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinch(sender:)))
    view.addGestureRecognizer(pinchGesture)
    
    let twoPointPanGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleDoublePan(sender:)))
    twoPointPanGesture.delegate = context.coordinator
    view.addGestureRecognizer(twoPointPanGesture)
    
    return view
  }
  
  public func updateUIView(_ uiView: UIViewType, context: Context) { }
  
  public func makeCoordinator() -> Coordinator {
    return Coordinator(parent: self)
  }
  
  public class Coordinator: NSObject, UIGestureRecognizerDelegate {
    
    var parent: ZoomGesture
    
    init(parent: ZoomGesture) {
      self.parent = parent
    }
    
    @objc
    func handlePinch(sender: UIPinchGestureRecognizer) {
      if sender.state == .began || sender.state == .changed {
        parent.scale = sender.scale - 1
        
        let scalePoint = CGPoint(
          x: sender.location(in: sender.view).x / sender.view!.frame.size.width,
          y: sender.location(in: sender.view).y / sender.view!.frame.size.height)
        parent.scalePosition = parent.scalePosition == .zero ? scalePoint : parent.scalePosition
      } else {
        withAnimation(.smooth) {
          parent.scale = 0
          parent.scalePosition = .zero
        }
      }
    }
    
    @objc
    func handleDoublePan(sender: UIPanGestureRecognizer) {
      sender .maximumNumberOfTouches = 2
      
      if (sender.state == .began || sender.state == .changed) && parent.scale > 0 {
        if let view = sender.view {
          let translation = sender.translation(in: view)
          parent.offset = translation
        }
      } else {
        withAnimation(.smooth) {
          parent.offset = .zero
        }
      }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      return true
    }
  }
}
