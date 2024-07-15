import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DomainUser",
  dependencies: [
    Project.CommonDomain,
    External.moya,
    External.combineMoya
  ]
)
