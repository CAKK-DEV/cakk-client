import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureCakeShop",
  dependencies: [
    Project.Shared,
    Project.DomainCakeShop,
    Project.PreviewSupportCakeShop,
    Project.DomainSearch,
    Project.PreviewSupportSearch,
    Project.DomainUser,
    Project.PreviewSupportUser,
    External.Kingfisher,
    External.ExpandableText,
    External.LinkNavigator,
    External.KakaoSDKShare
  ]
)
