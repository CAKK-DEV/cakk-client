import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DomainCakeShop",
  dependencies: [
    Project.CommonDomain,
    External.moya,
    External.combineMoya
  ]
)
