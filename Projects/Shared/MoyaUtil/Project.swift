import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "MoyaUtil",
  dependencies: [
    .external(name: "Moya")
  ]
)