//
//  EditWorkingDayView.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import SwiftUI
import SwiftUIUtil
import DesignSystem

import DomainCakeShop

import Router
import DIContainer

struct EditWorkingDayView: View {
  
  // MARK: - Properties
  
  @StateObject private var viewModel: EditWorkingDayViewModel
  @EnvironmentObject private var router: Router
  @State private var selectedWorkingDay: WorkingDay = .sun
  
  @State private var isStartTimePickerShown = false
  @State private var isEndTimePickerShown = false
  
  
  // MARK: - Initializers
  
  init() {
    let diContainer = DIContainer.shared.container
    let viewModel = diContainer.resolve(EditWorkingDayViewModel.self)!
    _viewModel = .init(wrappedValue: viewModel)
  }
  
  
  // MARK: - Views
  
  var body: some View {
    VStack(spacing: 0) {
      NavigationBar {
        Button {
          if viewModel.hasChanges() {
            DialogManager.shared.showDialog(
              title: "저장",
              message: "저장되지 않은 내용이 있어요.\n내용을 저장하지 않고 나갈까요??",
              primaryButtonTitle: "네",
              primaryButtonAction: .custom({
                router.navigateBack()
              }),
              secondaryButtonTitle: "머무르기", secondaryButtonAction: .cancel)
          } else {
            router.navigateBack()
          }
        } label: {
          Image(systemName: "arrow.left")
            .font(.system(size: 20))
            .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
        }
      } centerContent: {
        Text("가게 영업시간")
          .font(.pretendard(size: 17, weight: .bold))
          .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
      }
      
      ScrollView(.vertical) {
        VStack(spacing: 12) {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
              ForEach(WorkingDay.allCases, id: \.self) { workingDay in
                let isSelected = workingDay == selectedWorkingDay
                RoundedRectangle(cornerRadius: 16)
                  .fill(isSelected
                        ? DesignSystemAsset.gray70.swiftUIColor
                        : DesignSystemAsset.gray10.swiftUIColor)
                  .size(52)
                  .overlay {
                    Text(workingDay.displayName)
                      .font(.pretendard(size: 17, weight: .bold))
                      .foregroundStyle(isSelected
                                       ? DesignSystemAsset.gray10.swiftUIColor
                                       : DesignSystemAsset.gray70.swiftUIColor)
                  }
                  .onTapGesture {
                    selectedWorkingDay = workingDay
                    
                    withAnimation(.snappy) {
                      isStartTimePickerShown = false
                      isEndTimePickerShown = false
                    }
                  }
              }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
          }
          
          if viewModel.isWorkingDay(selectedWorkingDay) {
            workingTimePicker()
              .padding(.horizontal, 24)
          } else {
            emptyWorkingTimeView()
          }
        }
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .overlay {
      VStack {
        VStack(spacing: 0) {
          LinearGradient(colors: [.clear, .white], startPoint: .top, endPoint: .bottom)
            .frame(height: 20)
            .overlay {
              if viewModel.isWorkingDay(selectedWorkingDay) {
                Button {
                  viewModel.deleteWorkingDay(selectedWorkingDay)
                } label: {
                  Text("영업 시간 삭제")
                    .font(.pretendard(size: 15, weight: .bold))
                    .foregroundStyle(DesignSystemAsset.gray40.swiftUIColor)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 8)
                    .background(Color.white.blur(radius: 12))
                }
                .padding(.bottom, 20)
              }
            }
          
          CKButtonLarge(title: "저장", fixedSize: .infinity, action: {
            DialogManager.shared.showDialog(
              title: "저장",
              message: "정말 이 상태로 저장할까요?",
              primaryButtonTitle: "확인",
              primaryButtonAction: .custom({
                viewModel.updateWorkingDays()
              }),
              secondaryButtonTitle: "취소",
              secondaryButtonAction: .cancel)
          }, isLoading: .constant(viewModel.updatingState == .loading))
          .padding(.horizontal, 28)
          .padding(.vertical, 16)
          .background(Color.white.ignoresSafeArea())
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    .onReceive(viewModel.$updatingState) { newState in
      switch newState {
      case .failure:
        DialogManager.shared.showDialog(
          title: "정보 업데이트 실패",
          message: "영업 시간 업데이트에 실패하였어요\n다시 시도해주세요",
          primaryButtonTitle: "확인",
          primaryButtonAction: .cancel)
        
      case .loading:
        LoadingManager.shared.startLoading()
        return
        
      case .success:
        DialogManager.shared.showDialog(
          title: "업데이트 성공",
          message: "영업 시간 업데이트에 성공하였어요",
          primaryButtonTitle: "확인",
          primaryButtonAction: .cancel)
        
      default:
        break
      }
      
      LoadingManager.shared.stopLoading()
    }
  }
  
  private func workingTimePicker() -> some View {
    VStack(spacing: 20) {
      VStack(spacing: 8) {
        SectionHeaderCompact(title: "영업 시작 시간")
        
        VStack(spacing: 0) {
          HStack {
            Text(viewModel.formattedStartTimeString(of: selectedWorkingDay))
              .font(.pretendard(size: 15, weight: .semiBold))
              .frame(maxWidth: .infinity, alignment: .leading)
              .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
            
            DesignSystemAsset.calendarClock.swiftUIImage
              .resizable()
              .size(20)
              .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
          }
          .contentShape(Rectangle())
          .padding(.horizontal, 20)
          .padding(.vertical, 16)
          .onTapGesture {
            withAnimation(.snappy) {
              isStartTimePickerShown.toggle()
              isEndTimePickerShown = false
            }
          }
          
          if isStartTimePickerShown {
            DatePicker(
              "",
              selection: .init(get: {
                viewModel.getStartTime(of: selectedWorkingDay)
              }, set: { date in
                viewModel.updateStartTime(of: selectedWorkingDay, time: date)
              }),
              in: ...viewModel.getEndTime(of: selectedWorkingDay),
              displayedComponents: .hourAndMinute)
            .datePickerStyle(.wheel)
            .labelsHidden()
          }
        }
        .overlay {
          RoundedRectangle(cornerRadius: isStartTimePickerShown ? 22 : 14)
            .stroke(DesignSystemAsset.gray30.swiftUIColor, lineWidth: 1)
        }
      }
      
      VStack(spacing: 8) {
        SectionHeaderCompact(title: "영업 종료 시간")
        
        VStack(spacing: 0) {
          HStack {
            Text(viewModel.formattedEndTimeString(of: selectedWorkingDay))
              .font(.pretendard(size: 15, weight: .semiBold))
              .frame(maxWidth: .infinity, alignment: .leading)
              .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
            
            DesignSystemAsset.calendarClock.swiftUIImage
              .resizable()
              .size(20)
              .foregroundStyle(DesignSystemAsset.black.swiftUIColor)
          }
          .contentShape(Rectangle())
          .padding(.horizontal, 20)
          .padding(.vertical, 16)
          .onTapGesture {
            withAnimation(.snappy) {
              isEndTimePickerShown.toggle()
              isStartTimePickerShown = false
            }
          }
          
          if isEndTimePickerShown {
            DatePicker(
              "",
              selection: .init(get: {
                viewModel.getEndTime(of: selectedWorkingDay)
              }, set: { date in
                viewModel.updateEndTime(of: selectedWorkingDay, time: date)
              }),
              in: Calendar.current.date(byAdding: .minute, value: 1, to: viewModel.getStartTime(of: selectedWorkingDay))!...,
              displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
          }
        }
        .overlay {
          RoundedRectangle(cornerRadius: isEndTimePickerShown ? 22 : 14)
            .stroke(DesignSystemAsset.gray30.swiftUIColor, lineWidth: 1)
        }
      }
    }
  }
  
  private func emptyWorkingTimeView() -> some View {
    VStack(spacing: 28) {
      FailureStateView(title: "영업시간이 설정 되지 않았어요")
      
      Button {
        viewModel.addWorkingDay(selectedWorkingDay)
      } label: {
        Text("영업 시간 설정")
          .font(.pretendard(size: 15, weight: .bold))
          .foregroundStyle(DesignSystemAsset.gray70.swiftUIColor)
          .padding(.horizontal, 28)
          .frame(height: 48)
          .background(RoundedRectangle(cornerRadius: 12).fill(DesignSystemAsset.gray10.swiftUIColor))
      }
    }
    .frame(minHeight: 400)
  }
  
  
  // MARK: - Private Methods
  
//  private func formatTime() -> String {
//    
//  }
}


// MARK: - Preview

import PreviewSupportCakeShopAdmin

#Preview {
  let diContainer = DIContainer.shared.container
  diContainer.register(EditWorkingDayViewModel.self) { _ in
    let editWorkingDayUseCase = MockEditWorkingDayUseCase()
    return EditWorkingDayViewModel(
      shopId: 0,
      editWorkingDayUseCase: editWorkingDayUseCase,
      workingDaysWithTime: [
        .init(workingDay: .sun, startTime: "11:00", endTime: "21:00"),
        .init(workingDay: .tue, startTime: "11:00", endTime: "21:00")
      ]
    )
  }
  return EditWorkingDayView()
}
