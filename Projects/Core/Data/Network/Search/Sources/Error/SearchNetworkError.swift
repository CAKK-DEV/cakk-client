//
//  SearchNetworkError.swift
//  NetworkSearch
//
//  Created by 이승기 on 6/15/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation

public enum SearchNetworkError: Error {
  case customClientError(ClientErrorCode, String)
  case customServerError(ServerErrorCode, String)
  case unexpected(Error)
  case decodingError(Error)
  case dataIsNil
  
  public enum ClientErrorCode: String {
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

  public static func error(for error: Error) -> SearchNetworkError {
    if let urlError = error as? URLError {
      return .unexpected(urlError)
    } else if let networkError = error as? SearchNetworkError {
      return networkError
    } else if let decodingError = error as? DecodingError {
      return .decodingError(decodingError)
    } else {
      return .unexpected(error)
    }
  }
  
  public static func customError(for code: String, message: String) -> SearchNetworkError {
    if let clientErrorCode = ClientErrorCode(rawValue: code) {
      return .customClientError(clientErrorCode, message)
    } else if let serverErrorCode = ServerErrorCode(rawValue: code) {
      return .customServerError(serverErrorCode, message)
    } else {
      return .unexpected(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error code: \(code)"]))
    }
  }
}