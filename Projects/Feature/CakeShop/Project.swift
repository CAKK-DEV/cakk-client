import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureCakeShop",
  dependencies: [
    Project.SwiftUIUtil,
    Project.DesignSystem,
    Project.Router,
    Project.NetworkCakeShop,
    Project.DomainCakeShop,
    .external(name: "Swinject")
  ]
)
