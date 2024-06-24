//
//  BusinessRepository.swift
//  DomainBusiness
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

public protocol BusinessRepository {
  func uploadCertification(shopId: Int, businessRegistrationImage: UIImage, idCardImage: UIImage, contact: String, message: String, accessToken: String) -> AnyPublisher<Void, UploadCertificationError>
}
