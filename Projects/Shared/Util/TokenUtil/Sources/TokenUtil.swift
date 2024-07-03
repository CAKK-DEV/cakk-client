//
//  TokenType.swift
//  TokenUtil
//
//  Created by 이승기 on 5/30/24.
//  Copyright © 2024 cakk. All rights reserved.
//

import Foundation
import Security

public final class TokenUtil {
  
  // MARK: - TokenType
  
  public enum TokenType {
    case general
    case internet // 인터넷 암호 항목
    case cert // 인증서 암호 항목
    case encryptionKey // 암호화 키 항복
    case id // id 항목
    
    var kSecClass: CFString {
      switch self {
      case .general:
        return kSecClassGenericPassword
      case .internet:
        return kSecClassInternetPassword
      case .cert:
        return kSecClassCertificate
      case .encryptionKey:
        return kSecClassKey
      case .id:
        return kSecClassIdentity
      }
    }
  }
  
  
  // MARK: - Initializers
  
  public init() { }
  
  
  // MARK: - Public Methods
  
  public func create(_ service: String, account: String, value: String, type tokenType: TokenType = .general) {
    let keyChainQuery: [String: Any] = [
      kSecClass as String: tokenType.kSecClass,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecValueData as String: value.data(using: .utf8, allowLossyConversion: false)!
    ]
    SecItemDelete(keyChainQuery as CFDictionary) // Ensure old item is deleted
    let status: OSStatus = SecItemAdd(keyChainQuery as CFDictionary, nil)
    if status == errSecSuccess {
      print("Token saved successfully.")
    } else {
      print("Failed to save token, status code = \(status)")
      if let error = SecCopyErrorMessageString(status, nil) {
        print("Error message: \(error)")
      }
    }
  }
  
  public func read(_ service: String, account: String, type tokenType: TokenType = .general) -> String? {
    let keyChainQuery: NSDictionary = [
      kSecClass: tokenType.kSecClass,
      kSecAttrService: service,
      kSecAttrAccount: account,
      kSecReturnData: kCFBooleanTrue!,
      kSecMatchLimit: kSecMatchLimitOne
    ]
    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(keyChainQuery, &dataTypeRef)
    if status == errSecSuccess {
      let retrievedData = dataTypeRef as! Data
      return String(data: retrievedData, encoding: .utf8)
    } else {
      print("Failed to load token, status code = \(status)")
      return nil
    }
  }
  
  public func delete(_ service: String, account: String, type tokenType: TokenType = .general) {
    let keyChainQuery: [String: Any] = [
      kSecClass as String: tokenType.kSecClass,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account
    ]
    let status = SecItemDelete(keyChainQuery as CFDictionary)
    
    if status == errSecSuccess {
      print("Successfully deleted the token.")
    } else if status == errSecItemNotFound {
      print("Item not found, nothing to delete.")
    } else {
      print("Failed to delete the token, status code = \(status)")
    }
  }
}
