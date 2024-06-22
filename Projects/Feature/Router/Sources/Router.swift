//
//  Router.swift
//  CAKK
//
//  Created by 이승기 on 5/16/24.
//

import SwiftUI

public final class Router: ObservableObject {
  
  // MARK: - Properties
  
  @Published public var navPath = NavigationPath()
  @Published public var presentedSheet: AnyIdentifiable?
  @Published public var presentedFullScreenSheet: AnyIdentifiable?
  @Published public var root: AnyIdentifiable?
  
  public enum SheetStyle {
    case `default`
    case fullScreen
  }
  
  
  // MARK: - Initializers
  
  public init() { }
  
  
  // MARK: - Public Methods
  
  public func presentSheet(
    destination: any Identifiable,
    sheetStyle: SheetStyle = .default
  ) {
    switch sheetStyle {
    case .default:
      presentSheet(destination: destination)
    case .fullScreen:
      presentFullScreenSheet(destination: destination)
    }
  }
  
  public func navigate(to destination: any Hashable) {
    presentedSheet = nil
    presentedFullScreenSheet = nil
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
  
  
  // MARK: - Private Methods
  
  private func presentSheet(destination: any Identifiable) {
    presentedFullScreenSheet = nil
    presentedSheet = AnyIdentifiable(destination: destination)
  }
  
  private func presentFullScreenSheet(destination: any Identifiable) {
    presentedSheet = nil
    presentedFullScreenSheet = AnyIdentifiable(destination: destination)
  }
}

public class AnyIdentifiable: Identifiable, Equatable {
  public let destination: any Identifiable
  
  public init(destination: any Identifiable) {
    self.destination = destination
  }
  
  public static func == (lhs: AnyIdentifiable, rhs: AnyIdentifiable) -> Bool {
    lhs.id == rhs.id
  }
}
