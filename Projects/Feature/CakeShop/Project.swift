import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureCakeShop",
  dependencies: [
    .project(target: "SwiftUIUtil", path: "../../Shared/Util/SwiftUIUtil"),
    .project(target: "DIContainer", path: "../../Shared/DIContainer"),
    .project(target: "DesignSystem", path: "../../DesignSystem"),
    .project(target: "Router", path: "../Router"),
    .project(target: "NetworkCakeShop", path: "../../Core/Data/Network/CakeShop"),
    .project(target: "DomainCakeShop", path: "../../Core/Domain/CakeShop")
  ]
)