//
//  BusinessOwnerNetworkError.swift
//  NetworkBusinessOwner
//
//  Created by 이승기 on 6/25/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public enum BusinessOwnerNetworkError: Error {
  case customClientError(ClientErrorCode, String)
  case customServerError(ServerErrorCode, String)
  case unexpected(Error)
  case decodingError(Error)
  case dataIsNil
  
  public enum ClientErrorCode: String {
    case notExistBearerSuffix = "1100"
    case wrongJwtToken = "1101"
    case expiredJwtToken = "1102"
    case emptyAuthJwt = "1103"
    case emptyUser = "1104"
    case wrongProvider = "1200"
    case notExistUser = "1201"
    case alreadyExistUser = "1202"
    case notExistCakeShop = "1210"
    case wrongParameter = "9000"
    case methodNotAllowed = "9001"
    
    static func isClientError(code: String) -> Bool {
      return ClientErrorCode(rawValue: code) != nil
    }
  }
  
  public enum ServerErrorCode: String {
    case internalServerError = "9998"
    case externalServerError = "9999"
    
    static func isServerError(code: String) -> Bool {
      return ServerErrorCode(rawValue: code) != nil
    }
  }

  public static func error(for error: Error) -> BusinessOwnerNetworkError {
    if let urlError = error as? URLError {
      return .unexpected(urlError)
    } else if let networkError = error as? BusinessOwnerNetworkError {
      return networkError
    } else if let decodingError = error as? DecodingError {
      return .decodingError(decodingError)
    } else {
      return .unexpected(error)
    }
  }
  
  public static func customError(for code: String, message: String) -> BusinessOwnerNetworkError {
    if let clientErrorCode = ClientErrorCode(rawValue: code) {
      return .customClientError(clientErrorCode, message)
    } else if let serverErrorCode = ServerErrorCode(rawValue: code) {
      return .customServerError(serverErrorCode, message)
    } else {
      return .unexpected(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error code: \(code)"]))
    }
  }
}
