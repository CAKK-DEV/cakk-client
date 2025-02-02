import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureUser",
  dependencies: [
    Project.Shared,

    Project.DomainCakeShop, // TODO: #1 번 todo 삭제되면 같이 삭제
    
    Project.DomainUser,
    Project.DomainBusinessOwner,
    
    Project.PreviewSupportUser,
    Project.PreviewSupportSearch,
    
    Project.UserSession,

    External.KakaoSDKCommon,
    External.KakaoSDKAuth,
    External.KakaoSDKUser,
    External.Kingfisher,
    External.LinkNavigator,
    .package(product: "GoogleSignIn")
  ],
  packages: [
    .remote(url: "https://github.com/google/GoogleSignIn-iOS", requirement: .upToNextMajor(from: "7.1.0"))
  ]
)
