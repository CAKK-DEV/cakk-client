//
//  EditProfileView.swift
//  FeatureUser
//
//  Created by 이승기 on 6/5/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import DesignSystem
import SwiftUIUtil
import UIKitUtil
import Router

import DomainUser

struct EditProfileView: View {
  
  // MARK: - Properties
  
  @EnvironmentObject private var router: Router
  
  @State private var gender: Gender = .female
  @State private var birthday: Date = .now
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      NavigationBar(leadingContent: {
        Button {
          router.navigateBack()
        } label: {
          Image(systemName: "arrow.left")
            .font(.system(size: 20))
            .frame(width: 40, height: 40)
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        }
      }, centerContent: {
        Text("회원 정보 수정")
          .font(.pretendard(size: 17, weight: .semiBold))
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      })
      
      ZStack(alignment: .bottom) {
        ScrollView {
          VStack(spacing: 20) {
            ProfileImageView()
              .overlay {
                HStack(spacing: 0) {
                  Spacer()
                  VStack(spacing: 0) {
                    Spacer()
                    Circle()
                      .fill(DesignSystemAsset.gray70.swiftUIColor)
                      .size(36)
                      .overlay {
                        DesignSystemAsset.camera.swiftUIImage
                          .resizable()
                          .size(16)
                          .foregroundStyle(Color.white)
                      }
                  }
                }
              }
              .padding(.top, 20)
            
            CKTextField(text: .constant("홍길동"), placeholder: "홍길동", headerTitle: "이름")
            CKTextField(text: .constant("avocado34.131@gmail.com"), headerTitle: "이메일", isDisabled: true)
            
            genderPicker()
            birthdaySelector()
            
            HStack(spacing: 0) {
              Button("로그아웃") {
                // no action
              }
              .font(.pretendard(size: 15, weight: .medium))
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
              
              Button("회원탈퇴") {
                // no action
              }
              .font(.pretendard(size: 15, weight: .medium))
              .padding(.horizontal, 12)
              .padding(.vertical, 8)
            }
            .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
            .padding(.top, 128)
          }
          .frame(maxWidth: .infinity)
          .padding(.horizontal, 20)
          .padding(.bottom, 100)
        }
        
        VStack(spacing: 0) {
          CKButtonLarge(title: "저장", fixedSize: .infinity)
            .padding(.horizontal, 28)
            .padding(.bottom, 16)
        }
        .background {
          LinearGradient(colors: [.clear, .white, .white],
                         startPoint: .top,
                         endPoint: .bottom)
          .ignoresSafeArea()
        }
      }
    }
  }
  
  private func genderPicker() -> some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(title: "성별")
      
      HStack(spacing: 20) {
        Text(gender.displayName)
          .font(.pretendard(size: 15, weight: .medium))
          .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Image(systemName: "chevron.down")
          .font(.system(size: 20))
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      }
      .overlay {
        HStack {
          Spacer()
          
          Picker("성별", selection: $gender) {
            ForEach(Gender.allCases, id: \.self) { gender in
              Button {
                // action
              } label: {
                Text(gender.displayName)
                Image(uiImage: UIImage.generated(fromEmoji: gender.emoji, fontSize: 17)!)
              }
            }
          }
          .opacity(0.011)
        }
      }
      .frame(height: 52)
      .padding(.horizontal, 4)
    }
  }
  
  private func birthdaySelector() -> some View {
    VStack(spacing: 0) {
      SectionHeaderCompact(title: "생년월일")
      Text(birthday.formatted(.dateTime.day().month().year()))
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 52)
        .foregroundStyle(DesignSystemAsset.gray50.swiftUIColor)
        .overlay {
          HStack {
            DatePicker(selection: $birthday, in: ...Date(), displayedComponents: .date) {}
              .labelsHidden()
              .contentShape(Rectangle())
              .opacity(0.011)
            Spacer()
          }
        }
    }
  }
}


// MARK: - Preview

#Preview {
  EditProfileView()
}
