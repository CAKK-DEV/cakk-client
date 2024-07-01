//
//  EditWorkingDayUseCase.swift
//  DomainCakeShop
//
//  Created by 이승기 on 6/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Combine

public protocol EditWorkingDayUseCase {
  func execute(shopId: Int, workingDaysWithTime: [WorkingDayWithTime]) -> AnyPublisher<Void, CakeShopError>
}
