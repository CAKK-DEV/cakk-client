import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureUser",
  dependencies: [
    Project.SwiftUIUtil,
    Project.DesignSystem,
    Project.Router,
    Project.DomainUser,
    Project.UIKitUtil,
    Project.UserSession,
    Project.PreviewSupportUser,
    Project.DIContainer,
    External.kakaoSDKCommon,
    External.kakaoSDKAuth,
    External.kakaoSDKUser,
    .package(product: "GoogleSignIn")
  ],
  packages: [
    .remote(url: "https://github.com/google/GoogleSignIn-iOS", requirement: .upToNextMajor(from: "7.1.0"))
  ]
)
