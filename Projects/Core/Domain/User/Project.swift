import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DomainUser",
  dependencies: [
    External.moya,
    External.combineMoya
  ]
)
