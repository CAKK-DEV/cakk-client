import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DomainBusinessOwner",
  dependencies: [
    External.moya,
    External.combineMoya
  ]
)
