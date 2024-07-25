import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DomainUser",
  dependencies: [
    Project.CommonDomain,
    External.Moya,
    External.CombineMoya
  ]
)
