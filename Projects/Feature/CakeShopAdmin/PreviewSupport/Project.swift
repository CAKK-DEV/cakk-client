import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "PreviewSupportCakeShopAdmin",
  dependencies: [
    Project.DomainCakeShop,
    Project.SwiftUIUtil,
    Project.Router,
    Project.DIContainer
  ]
)
