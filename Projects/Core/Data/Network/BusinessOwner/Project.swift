import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "NetworkBusinessOwner",
  infoPlist: [
    "BASE_URL": "$(BASE_URL)"
  ],
  dependencies: [
    Project.DomainBusinessOwner,
    Project.UserSession,
    Project.NetworkImage,
    Project.Logger
  ],
  supportsResources: true
)
