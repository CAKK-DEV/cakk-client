//
//  UploadCertificationError.swift
//  DomainBusiness
//
//  Created by 이승기 on 6/23/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public enum UploadCertificationError: Error {
  case failure
  case imageUploadFailure
  case sessionExpired
  case serverError
}
