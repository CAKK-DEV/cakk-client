import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureCakeShop",
  dependencies: [
    Project.SwiftUIUtil,
    Project.DIContainer,
    Project.DesignSystem,
    Project.Router,
    Project.NetworkCakeShop,
    Project.DomainCakeShop
  ]
)
