//
//  StepNavigationView.swift
//  CAKK
//
//  Created by 이승기 on 5/8/24.
//

import SwiftUI

public struct StepNavigationView: View {
  
  // MARK: - Properties
  
  let title: String
  let onTapBackButton: (() -> Void)?
  
  @State private var isAppearing = false
  
  
  // MARK: - Initializers
  
  public init(
    title: String,
    onTapBackButton: (() -> Void)? = nil)
  {
    self.title = title
    self.onTapBackButton = onTapBackButton
  }
  
  // MARK: - Views
  
  public var body: some View {
    HStack {
      Spacer()
        .overlay {
          if let onTapBackButton {
            HStack {
              Button {
                onTapBackButton()
              } label: {
                Image(systemName: "chevron.left")
                  .font(.system(size: 24))
                  .foregroundStyle(Color.white)
              }
              
              Spacer()
            }
            .padding(20)
          }
        }
      
      Text(title)
        .font(.system(size: 20, weight: .bold, design: .rounded))
        .foregroundStyle(Color.white.opacity(0.5))
        .scaleEffect(isAppearing ? 1.0 : 1.2)
      
      Spacer()
    }
    .frame(maxWidth: .infinity)
    .frame(height: 72)
    .onAppear {
      withAnimation(.bouncy(duration: 1)) {
        isAppearing = true
      }
    }
  }
}


// MARK: - Preview

#Preview {
  StepNavigationView(title: "1 / 3")
    .background(Color.black)
}
