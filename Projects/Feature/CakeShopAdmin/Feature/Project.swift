import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureCakeShopAdmin",
  dependencies: [
    Project.SwiftUIUtil,
    Project.DesignSystem,
    
    Project.DomainSearch,
    Project.PreviewSupportSearch,

    Project.DomainCakeShop,
    Project.PreviewSupportCakeShop,
    Project.PreviewSupportCakeShopAdmin,

    Project.Router,
    Project.DIContainer,
    External.kingfisher
  ]
)
