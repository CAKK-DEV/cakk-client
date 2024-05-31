import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DomainUser",
  dependencies: [
    .external(name: "Moya"),
    .external(name: "CombineMoya")
  ]
)
