//
//  ImageUploadRepository.swift
//  NetworkImage
//
//  Created by 이승기 on 7/11/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import UIKit
import Combine

import Moya
import CombineMoya

public final class ImageUploadRepository {
  
  // MARK: - Properties
  
  private let provider: MoyaProvider<ImageUploadAPI>
  
  
  // MARK: - Initializers
  
  public init(provider: MoyaProvider<ImageUploadAPI>) {
    self.provider = provider
  }
  
  
  // MARK: - Public Methods
  
  /// PresignedUrl 요청 후 해당 url에 이미지를 업로드 한 후 imageUrl을 반환합니다.
  public func uploadImage(image: UIImage) -> AnyPublisher<String, ImageUploadError> {
    provider.requestPublisher(.requestPresignedUrl)
      .tryMap { response -> (String, String) in
        switch response.statusCode {
        case 200..<300:
          let decodedResponse = try JSONDecoder().decode(PresignedUrlResponseDTO.self, from: response.data)
          let presignedUrl = decodedResponse.data.presignedUrl
          let imageUrl = decodedResponse.data.imageUrl
          return (presignedUrl, imageUrl)
          
        default:
          throw ImageUploadError.failure
        }
      }
      .flatMap { [provider] (presignedUrl, imageUrl) -> AnyPublisher<String, Error> in
        // TODO: - Webp로 변환하도록 변경
        guard let data = image.jpegData(compressionQuality: 1) else {
          return Fail(error: ImageUploadError.failure).eraseToAnyPublisher()
        }
        /// 이미지를 webP 형식으로 변환 후 PresignedURL에 업로드 합니다.
//        SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
//        guard let data = image.sd_imageData(as: .webP, compressionQuality: 1) else {
//          return Fail(error: UploadCertificationError.imageUploadFailure).eraseToAnyPublisher()
//        }
        
        return provider.requestPublisher(.uploadPresignedImage(presignedUrl: presignedUrl, image: data))
        .map { _ in imageUrl }
        .mapError { _ in ImageUploadError.failure }
        .eraseToAnyPublisher()
      }
      .mapError { _ in ImageUploadError.failure }
      .eraseToAnyPublisher()
  }
}
