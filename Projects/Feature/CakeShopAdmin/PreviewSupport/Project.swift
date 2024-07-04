import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "PreviewSupportCakeShopAdmin",
  dependencies: [
    Project.DomainCakeShop,
    Project.CommonUtil,
    Project.Router,
    Project.DIContainer
  ]
)
