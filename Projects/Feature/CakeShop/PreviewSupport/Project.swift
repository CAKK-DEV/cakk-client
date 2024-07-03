import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "PreviewSupportCakeShop",
  dependencies: [
    Project.DomainCakeShop,
    Project.DIContainer
  ]
)
