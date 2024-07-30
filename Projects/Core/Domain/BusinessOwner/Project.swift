import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DomainBusinessOwner",
  dependencies: [
    Project.CommonDomain,
    External.Moya,
    External.CombineMoya
  ]
)
