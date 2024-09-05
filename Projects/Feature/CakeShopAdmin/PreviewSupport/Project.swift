import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "PreviewSupportCakeShopAdmin",
  dependencies: [
    Project.Shared,
    Project.DomainCakeShop,
  ]
)
