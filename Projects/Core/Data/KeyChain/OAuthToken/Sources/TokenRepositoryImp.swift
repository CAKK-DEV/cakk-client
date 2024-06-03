import Foundation

import TokenUtil
import DomainOAuthToken

public final class OAuthTokenRepositoryImpl: OAuthTokenRepository {
  
  // MARK: - Properties
  
  private let tokenUtil = TokenUtil()
  private let serviceName = "com.prography.CAKK"
  
  
  // MARK: - Initializers

  public init() { }
  
  
  // MARK: - Public Method
  
  public func saveAccessToken(_ token: String) {
    tokenUtil.create(serviceName, account: "accessToken", value: token)
  }
  
  public func getAccessToken() -> String? {
    tokenUtil.read(serviceName, account: "accessToken")
  }
  
  public func deleteAccessToken() {
    tokenUtil.delete(serviceName, account: "accessToken")
  }
  
  public func saveRefreshToken(_ token: String) {
    tokenUtil.create(serviceName, account: "refreshToken", value: token)
  }
  
  public func getRefreshToken() -> String? {
    tokenUtil.read(serviceName, account: "refreshToken")
  }
  
  public func deleteRefreshToken() {
    tokenUtil.delete(serviceName, account: "refreshToken")
  }
}
