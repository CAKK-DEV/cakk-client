import ProjectDescription

public extension Project {
  
  // MARK: - Shared
  
  static let DIContainer: TargetDependency = .project(
    target: "DIContainer",
    path: .relativeToRoot("Projects/Shared/DIContainer")
  )
  
  static let MoyaUtil: TargetDependency = .project(
    target: "MoyaUtil",
    path: .relativeToRoot("Projects/Shared/Util/MoyaUtil")
  )
  
  static let SwiftUIUtil: TargetDependency = .project(
    target: "SwiftUIUtil",
    path: .relativeToRoot("Projects/Shared/Util/SwiftUIUtil")
  )
  
  static let TokenUtil: TargetDependency = .project(
    target: "TokenUtil",
    path: .relativeToRoot("Projects/Shared/Util/TokenUtil")
  )
  
  
  // MARK: - DesignSystem
  
  static let DesignSystem: TargetDependency = .project(
    target: "DesignSystem",
    path: .relativeToRoot("Projects/DesignSystem")
  )
  
  
  // MARK: - Core / Domain
  
  static let DomainUser: TargetDependency = .project(
    target: "DomainUser",
    path: .relativeToRoot("Projects/Core/Domain/User")
  )
  
  static let DomainOAuthToken: TargetDependency = .project(
    target: "DomainOAuthToken",
    path: .relativeToRoot("Projects/Core/Domain/OAuthToken")
  )
  
  static let DomainCakeShop: TargetDependency = .project(
    target: "DomainCakeShop",
    path: .relativeToRoot("Projects/Core/Domain/CakeShop")
  )
  
  
  // MARK: - Core / Data / Network
  
  static let NetworkCakeShop: TargetDependency = .project(
    target: "NetworkCakeShop",
    path: .relativeToRoot("Projects/Core/Data/Network/CakeShop")
  )
  
  static let NetworkUser: TargetDependency = .project(
    target: "NetworkUser",
    path: .relativeToRoot("Projects/Core/Data/Network/User")
  )
  
  
  // MARK: - Core / Data / KeyChain
  
  static let KeyChainOAuthToken: TargetDependency = .project(
    target: "OAuthToken",
    path: .relativeToRoot("Projects/Core/Data/KeyChain/OAuthToken")
  )
  
  
  // MARK: - Feature
  
  static let FeatureCakeShop: TargetDependency = .project(
    target: "FeatureCakeShop",
    path: .relativeToRoot("Projects/Feature/CakeShop")
  )
  
  static let FeatureLogin: TargetDependency = .project(
    target: "FeatureLogin",
    path: .relativeToRoot("Projects/Feature/Login")
  )
  
  static let FeatureOnboarding: TargetDependency = .project(
    target: "FeatureOnboarding",
    path: .relativeToRoot("Projects/Feature/Onboarding")
  )
  
  
  // MARK: - Feature / Example
  
  
  static let ExampleCakeShop: TargetDependency = .project(
    target: "ExampleCakeShop",
    path: .relativeToRoot("Projects/Feature/CakeShopExample")
  )
  
  static let ExampleLogin: TargetDependency = .project(
    target: "ExampleLogin",
    path: .relativeToRoot("Projects/Feature/LoginExample")
  )
  
  static let ExampleOnboarding: TargetDependency = .project(
    target: "ExampleOnboarding",
    path: .relativeToRoot("Projects/Feature/OnboardingExample")
  )
  
  
  // MARK: - Feature / Router
  
  static let Router: TargetDependency = .project(
    target: "Router",
    path: .relativeToRoot("Projects/Feature/Router")
  )
}
