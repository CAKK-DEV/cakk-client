import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DomainSearch",
  dependencies: [
    External.moya,
    External.combineMoya
  ]
)
