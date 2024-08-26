import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "NetworkUser",
  dependencies: [
    Project.DomainUser,
    Project.UserSession,
    Project.NetworkImage
  ],
  supportsResources: true
)
