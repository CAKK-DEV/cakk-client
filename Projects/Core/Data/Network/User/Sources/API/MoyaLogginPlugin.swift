//
//  MoyaLogginPlugin.swift
//  CAKK
//
//  Created by 이승기 on 5/15/24.
//

import Foundation
import Moya

import DomainUser

public final class MoyaLoggingPlugin: PluginType {
  
  // MARK: - Initializers
  
  public init() { }
  
  
  // MARK: - Methods
  
  // Request를 보낼 때 호출
  public func willSend(_ request: RequestType, target: TargetType) {
    guard let httpRequest = request.request else {
      print("❌ Invalid request")
      return
    }
    
    let url = httpRequest.description
    let method = httpRequest.httpMethod ?? "unknown method"
    var log = "🌐 [\(method)] \(url)\n"
    log.append("📋 API: \(target)\n")
    
    if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
      log.append("🔖 Headers: \(headers)\n")
    }
    
    if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
      log.append("📦 Body: \n\(bodyString)\n")
    }
    
    log.append("🔚 END \(method)")
    print(log)
  }
  
  // Response가 왔을 때
  public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    switch result {
    case let .success(response):
      onSucceed(response, target: target, isFromError: false)
    case let .failure(error):
      onFail(error, target: target)
    }
  }
  
  func onSucceed(_ response: Response, target: TargetType, isFromError: Bool) {
    let request = response.request
    let url = request?.url?.absoluteString ?? "nil"
    let statusCode = response.statusCode
    var log = "✅ Network Request Succeeded"
    log.append("\n[\(statusCode)] \(url)\n")
    log.append("📋 API: \(target)\n")
    
    response.response?.allHeaderFields.forEach {
      log.append("🔖 \($0): \($1)\n")
    }
    
    if let responseString = String(bytes: response.data, encoding: String.Encoding.utf8) {
      log.append("📦 Response: \n\(responseString)\n")
    }
    
    log.append("🔚 END HTTP (\(response.data.count)-byte body)")
    print(log)
  }
  
  func onFail(_ error: MoyaError, target: TargetType) {
    if let response = error.response {
      onSucceed(response, target: target, isFromError: true)
      return
    }
    var log = "❌ Network Error"
    log.append("\n<-- \(error.errorCode) \(target)\n")
    log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
    log.append("🔚 END HTTP")
    print(log)
  }
}

