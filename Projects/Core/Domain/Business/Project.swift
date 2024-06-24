import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DomainBusiness",
  dependencies: [
    External.moya,
    External.combineMoya
  ]
)
