import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureCakeShop",
  dependencies: [
    Project.SwiftUIUtil,
    Project.DIContainer,
    .project(target: "DesignSystem", path: "../../DesignSystem"),
    .project(target: "Router", path: "../Router"),
    .project(target: "NetworkCakeShop", path: "../../Core/Data/Network/CakeShop"),
    .project(target: "DomainCakeShop", path: "../../Core/Domain/CakeShop")
  ]
)
