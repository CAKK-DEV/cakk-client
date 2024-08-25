//
//  EditWorkingDayViewModel.swift
//  FeatureCakeShopAdmin
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

import CommonDomain
import DomainCakeShop

public final class EditWorkingDayViewModel: ObservableObject {
  
  // MARK: - Properties
  
  private let shopId: Int
  
  private var originalWorkingDaysWithTime = [WorkingDayWithTime]()
  @Published private(set) var workingDaysWithTime = [WorkingDayWithTime]()
  
  private let cakeShopAdditionalInfoUseCase: CakeShopAdditionalInfoUseCase
  @Published private(set) var workingDaysFetchingState: workingDaysFetchingState = .idle
  enum workingDaysFetchingState: Equatable {
    case idle
    case loading
    case failure
    case success
  }

  private let editWorkingDayUseCase: EditWorkingDayUseCase
  @Published private(set) var updatingState: UpdatingState = .idle
  enum UpdatingState {
    case idle
    case loading
    case success
    case failure
  }
  
  private var cancellables = Set<AnyCancellable>()
  
  private let shortDateFormatter = DateFormatter()
  private let regularDateFormatter = DateFormatter()
  
  
  // MARK: - Initializers
  
  public init(
    shopId: Int,
    cakeShopAdditionalInfoUseCase: CakeShopAdditionalInfoUseCase,
    editWorkingDayUseCase: EditWorkingDayUseCase
  ) {
    self.shopId = shopId
    self.cakeShopAdditionalInfoUseCase = cakeShopAdditionalInfoUseCase
    self.editWorkingDayUseCase = editWorkingDayUseCase
    
    shortDateFormatter.dateFormat = "HH:mm:ss"
    regularDateFormatter.dateFormat = "a hh:mm"
  }
  
  
  // MARK: - Public Methods
  
  public func fetchWorkingDay() {
    self.workingDaysFetchingState = .loading
    
    cakeShopAdditionalInfoUseCase.execute(shopId: shopId)
      .subscribe(on: DispatchQueue.global())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case .failure = completion {
          self?.workingDaysFetchingState = .failure
        } else {
          self?.workingDaysFetchingState = .success
        }
      } receiveValue: { [weak self] additionalInfo in
        self?.originalWorkingDaysWithTime = additionalInfo.workingDaysWithTime
        self?.workingDaysWithTime = additionalInfo.workingDaysWithTime
      }
      .store(in: &cancellables)
  }
  
  public func updateWorkingDays() {
    updatingState = .loading
    
    editWorkingDayUseCase.execute(shopId: shopId, workingDaysWithTime: workingDaysWithTime)
      .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.updatingState = .failure
          print(error.localizedDescription)
        } else {
          self?.updatingState = .success
        }
      } receiveValue: { _ in }
      .store(in: &cancellables)
  }
  
  public func isWorkingDay(_ workingDay: WorkingDay) -> Bool {
    workingDaysWithTime.contains(where: { $0.workingDay == workingDay })
  }
  
  public func hasChanges() -> Bool {
    if originalWorkingDaysWithTime == workingDaysWithTime {
      return false
    } else {
      return true
    }
  }
  
  public func addWorkingDay(_ workingDay: WorkingDay) {
    workingDaysWithTime.append(.init(workingDay: workingDay, startTime: "09:00:00", endTime: "17:00:00"))
  }
  
  public func deleteWorkingDay(_ workingDay: WorkingDay) {
    if let index = workingDaysWithTime.firstIndex(where: { $0.workingDay == workingDay }) {
      workingDaysWithTime.remove(at: index)
    }
  }
  
  public func getStartTime(of workingDay: WorkingDay) -> Date {
    if let index = workingDaysWithTime.firstIndex(where: { $0.workingDay == workingDay }) {
      return shortDateFormatter.date(from: workingDaysWithTime[index].startTime)!
    } else {
      return Date()
    }
  }
  
  public func updateStartTime(of workingDay: WorkingDay, time: Date) {
    let dateString = shortDateFormatter.string(from: time)
    if let index = workingDaysWithTime.firstIndex(where: { $0.workingDay == workingDay }) {
      workingDaysWithTime[index].startTime = dateString
    }
  }
  
  public func formattedStartTimeString(of workingDay: WorkingDay) -> String {
    if let index = workingDaysWithTime.firstIndex(where: { $0.workingDay == workingDay }) {
      let dateString = workingDaysWithTime[index].startTime
      let date = shortDateFormatter.date(from: dateString)!
      return regularDateFormatter.string(from: date)
    } else {
      return ""
    }
  }
  
  public func getEndTime(of workingDay: WorkingDay) -> Date {
    if let index = workingDaysWithTime.firstIndex(where: { $0.workingDay == workingDay }) {
      return shortDateFormatter.date(from: workingDaysWithTime[index].endTime)!
    } else {
      return Date()
    }
  }
  
  public func updateEndTime(of workingDay: WorkingDay, time: Date) {
    let dateString = shortDateFormatter.string(from: time)
    if let index = workingDaysWithTime.firstIndex(where: { $0.workingDay == workingDay }) {
      workingDaysWithTime[index].endTime = dateString
    }
  }
  
  public func formattedEndTimeString(of workingDay: WorkingDay) -> String {
    if let index = workingDaysWithTime.firstIndex(where: { $0.workingDay == workingDay }) {
      let dateString = workingDaysWithTime[index].endTime
      let date = shortDateFormatter.date(from: dateString)!
      return regularDateFormatter.string(from: date)
    } else {
      return ""
    }
  }
  
  
  // MARK: - Private Methods
  
}
