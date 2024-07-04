import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DomainBusinessOwner",
  dependencies: [
    Project.CommonDomain,
    External.moya,
    External.combineMoya
  ]
)
