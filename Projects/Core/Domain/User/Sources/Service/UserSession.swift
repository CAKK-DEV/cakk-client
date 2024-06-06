import Foundation

public protocol UserSession {
  static var shared: Self { get }
  
  var isSignedIn: Bool { get }
  func update(signInState isSignedIn: Bool)
  
  var userData: UserData? { get }
  func update(userData: UserData)
  
  var accessToken: String? { get }
  func update(accessToken: String)
  
  var refreshToken: String? { get } 
  func update(refreshToken: String)
}
