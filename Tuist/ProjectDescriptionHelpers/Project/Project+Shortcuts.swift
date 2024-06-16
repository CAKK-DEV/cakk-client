import ProjectDescription

public extension Project {
  
  // MARK: - Shared
  
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

  static let UIKitUtil: TargetDependency = .project(
    target: "UIKitUtil",
    path: .relativeToRoot("Projects/Shared/Util/UIKitUtil")
  )
  
  
  // MARK: - DesignSystem
  
  static let DesignSystem: TargetDependency = .project(
    target: "DesignSystem",
    path: .relativeToRoot("Projects/DesignSystem")
  )


  // MARK: - Core

   static let DIContainer: TargetDependency = .project(
    target: "DIContainer",
    path: .relativeToRoot("Projects/Core/DIContainer")
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

  static let DomainSearch: TargetDependency = .project(
    target: "DomainSearch",
    path: .relativeToRoot("Projects/Core/Domain/Search")
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

  static let NetworkSearch: TargetDependency = .project(
    target: "NetworkSearch",
    path: .relativeToRoot("Projects/Core/Data/Network/Search")
  )
  
  
  // MARK: - Core / Data / KeyChain
  
  static let KeyChainOAuthToken: TargetDependency = .project(
    target: "OAuthToken",
    path: .relativeToRoot("Projects/Core/Data/KeyChain/OAuthToken")
  )

  
  // MARK: - Core / Data / UserDefaults

  static let UserSession: TargetDependency = .project(
    target: "UserSession",
    path: .relativeToRoot("Projects/Core/Data/UserDefaults/UserSession")
  )

  static let UserDefaultsSearchHistory: TargetDependency = .project(
    target: "UserDefaultsSearchHistory",
    path: .relativeToRoot("Projects/Core/Data/UserDefaults/Search/SearchHistory")
  )
  
  
  // MARK: - Feature
  
  static let FeatureCakeShop: TargetDependency = .project(
    target: "FeatureCakeShop",
    path: .relativeToRoot("Projects/Feature/CakeShop/Feature")
  )
  
  static let FeatureUser: TargetDependency = .project(
    target: "FeatureUser",
    path: .relativeToRoot("Projects/Feature/User/Feature")
  )
  
  static let FeatureOnboarding: TargetDependency = .project(
    target: "FeatureOnboarding",
    path: .relativeToRoot("Projects/Feature/Onboarding/Feature")
  )

  static let FeatureSearch: TargetDependency = .project(
    target: "FeatureSearch",
    path: .relativeToRoot("Projects/Feature/Search/Feature")
  )
  
  
  // MARK: - Feature / Example
  
  static let ExampleCakeShop: TargetDependency = .project(
    target: "ExampleCakeShop",
    path: .relativeToRoot("Projects/Feature/CakeShop/Example")
  )
  
  static let ExampleUser: TargetDependency = .project(
    target: "ExampleUser",
    path: .relativeToRoot("Projects/Feature/User/Example")
  )
  
  static let ExampleOnboarding: TargetDependency = .project(
    target: "ExampleOnboarding",
    path: .relativeToRoot("Projects/Feature/Onboarding/Example")
  )

  static let ExampleSearch: TargetDependency = .project(
    target: "ExampleSearch",
    path: .relativeToRoot("Projects/Feature/Search/Example")
  )

  
  // MARK: - Feature / Preview Supports

  static let PreviewSupportUser: TargetDependency = .project(
    target: "PreviewSupportUser",
    path: .relativeToRoot("Projects/Feature/User/PreviewSupport")
  )

  static let PreviewSupportCakeShop: TargetDependency = .project(
    target: "PreviewSupportCakeShop",
    path: .relativeToRoot("Projects/Feature/CakeShop/PreviewSupport")
  )

  static let PreviewSupportSearch: TargetDependency = .project(
    target: "PreviewSupportSearch",
    path: .relativeToRoot("Projects/Feature/Search/PreviewSupport")
  )
  
  
  // MARK: - Feature / Router
  
  static let Router: TargetDependency = .project(
    target: "Router",
    path: .relativeToRoot("Projects/Feature/Router")
  )
}
