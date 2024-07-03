import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DomainCakeShop",
  dependencies: [
    External.moya,
    External.combineMoya
  ]
)
