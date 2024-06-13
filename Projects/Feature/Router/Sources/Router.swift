//
//  Router.swift
//  CAKK
//
//  Created by 이승기 on 5/16/24.
//

import SwiftUI

public class AnyIdentifiable: Identifiable, Equatable {
  public let destination: any Identifiable
  
  public init(destination: any Identifiable) {
    self.destination = destination
  }
  
  public static func == (lhs: AnyIdentifiable, rhs: AnyIdentifiable) -> Bool {
    lhs.id == rhs.id
  }
}

public final class Router: ObservableObject {
  @Published public var navPath = NavigationPath()
  @Published public var presentedSheet: AnyIdentifiable?
  @Published public var presentedFullScreenSheet: AnyIdentifiable?
  @Published public var root: AnyIdentifiable?
  
  public init() {}
  
  public func presentSheet(destination: any Identifiable) {
    presentedSheet = AnyIdentifiable(destination: destination)
  }
  
  public func presentFullScreenSheet(destination: any Identifiable) {
    presentedFullScreenSheet = AnyIdentifiable(destination: destination)
  }
  
  public func navigate(to destination: any Hashable) {
    presentedSheet = nil
    navPath.append(destination)
  }
  
  public func navigateBack() {
    navPath.removeLast()
  }
  
  public func navigateToRoot() {
    navPath.removeLast(navPath.count)
  }
  
  public func replace(with destination: any Identifiable) {
    self.root = AnyIdentifiable(destination: destination)
  }
}
