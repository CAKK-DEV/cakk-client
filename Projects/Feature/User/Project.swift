import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureUser",
  dependencies: [
    Project.SwiftUIUtil,
    Project.DIContainer,
    Project.DesignSystem,
    Project.Router,
    Project.NetworkUser,
    Project.DomainUser,
    .external(name: "KakaoSDKCommon"),
    .external(name: "KakaoSDKAuth"),
    .external(name: "KakaoSDKUser"),
    .package(product: "GoogleSignIn")
  ],
  packages: [
    .remote(url: "https://github.com/google/GoogleSignIn-iOS", requirement: .upToNextMajor(from: "7.1.0"))
  ]
)
