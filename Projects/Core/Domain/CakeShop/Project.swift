import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DomainCakeShop",
  dependencies: [
    .external(name: "Moya"),
    .external(name: "CombineMoya")
  ]
)
