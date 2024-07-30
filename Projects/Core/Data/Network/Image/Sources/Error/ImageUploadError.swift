//
//  ImageUploadError.swift
//  NetworkImage
//
//  Created by 이승기 on 7/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public enum ImageUploadError: Error {
  case imageConvertError /// 이미지 타입 변환 실패를 의미합니다
  case failure
}
