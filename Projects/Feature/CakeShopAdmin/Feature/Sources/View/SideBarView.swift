//
//  SideBarView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DIContainer

struct SidebarView: View {
  
  // MARK: - Properties
  
  // MARK: - Initializers
  
  // MARK: - Views
  
  var body: some View {
    let list = List {
      Section {
        NavigationLink(destination: BusinessOwnerRequestListView()) {
          Label("사장님 인증 요청", systemImage: "tray.2")
        }
      } header: {
        Text("사용자")
          .font(.title3)
          .bold()
      }
      
      Section {
        NavigationLink(destination: CakeShopListView()) {
          Label("등록된 가게", systemImage: "birthday.cake")
        }
        
        NavigationLink(destination: UploadCakeShopOptionView()) {
          Label {
            Text("케이크샵 추가")
          } icon: {
            Image(systemName: "plus.app.fill")
              .resizable()
              .size(28)
              .foregroundStyle(Color.gray)
              .symbolRenderingMode(.hierarchical)
          }
        }
      } header: {
        Text("케이크 샵")
          .font(.title3)
          .bold()
      }
    }.listStyle(SidebarListStyle())
    
    list
  }
}


// MARK: - Preview

import PreviewSupportSearch

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(CakeShopListViewModel.self) { _ in
    let useCase = MockSearchCakeShopUseCase()
    return CakeShopListViewModel(searchCakeShopUseCase: useCase)
  }
  
  return SidebarView()
}
