import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureLogin",
  dependencies: [
    .project(target: "SwiftUIUtil", path: "../../Shared/Util/SwiftUIUtil"),
    .project(target: "DIContainer", path: "../../Shared/DIContainer"),
    .project(target: "DesignSystem", path: "../../DesignSystem"),
    .project(target: "Router", path: "../Router"),
    .project(target: "NetworkUser", path: "../../Core/Data/Network/User"),
    .project(target: "DomainUser", path: "../../Core/Domain/User"),
    .external(name: "Moya"),
    .external(name: "CombineMoya"),
    .external(name: "KakaoSDKCommon"),
    .external(name: "KakaoSDKAuth"),
    .external(name: "KakaoSDKUser"),
    .package(product: "GoogleSignIn")
  ],
  packages: [
    .remote(url: "https://github.com/google/GoogleSignIn-iOS", requirement: .upToNextMajor(from: "7.1.0"))
  ]
)
