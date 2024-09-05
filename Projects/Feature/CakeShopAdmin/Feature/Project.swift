import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureCakeShopAdmin",
  dependencies: [
    Project.Shared,
    
    Project.DomainSearch,
    Project.PreviewSupportSearch,

    Project.DomainCakeShop,
    Project.PreviewSupportCakeShop,
    Project.PreviewSupportCakeShopAdmin,

    External.Kingfisher,
    External.LinkNavigator
  ]
)
