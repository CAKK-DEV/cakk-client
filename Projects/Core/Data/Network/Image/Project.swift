import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "NetworkImage",
  dependencies: [
    External.Moya,
    External.CombineMoya
  ]
)
