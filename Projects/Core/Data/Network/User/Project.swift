import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "NetworkUser",
  dependencies: [
    Project.DomainUser,
    Project.MoyaUtil
  ],
  supportsResources: true
)
