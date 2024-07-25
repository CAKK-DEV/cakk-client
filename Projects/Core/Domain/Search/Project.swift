import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DomainSearch",
  dependencies: [
    Project.CommonDomain,
    External.Moya,
    External.CombineMoya
  ]
)
