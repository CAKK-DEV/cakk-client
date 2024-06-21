//
//  MotionObserver.swift
//  DesignSystem
//
//  Created by 이승기 on 6/21/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import CoreMotion

class MotionObserver: ObservableObject {
  
  // MARK: - Properties
  
  @Published private(set) var motionManager = CMMotionManager()
  @Published private(set) var xValue: CGFloat = 0
  @Published private(set) var yValue: CGFloat = 0
  @Published private(set) var movingOffset: CGSize = .zero
  
  
  // MARK: - Methods
  
  func fetchMotionData(duration: CGFloat) {
    motionManager.startDeviceMotionUpdates(to: .main) { data, error in
      if let error {
        print(error.localizedDescription)
        return
      }
      
      guard let data else {
        print("Error in data")
        return
      }
      
      self.xValue = data.attitude.roll
      self.yValue = data.attitude.pitch
      self.movingOffset = self.getOffset(duration: duration)
    }
  }
  
  func getOffset(duration: CGFloat) -> CGSize {
    var width = xValue * duration
    var height = yValue * duration
    
    width = (width < 0 ? (-width > 30 ? -30 : width) : (width > 30 ? 30 : width))
    height = (height < 0 ? (-height > 30 ? -30 : height) : (height > 30 ? 30 : height))
    
    return CGSize(width: width, height: height)
  }
}