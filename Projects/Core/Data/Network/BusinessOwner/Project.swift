import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "NetworkBusinessOwner",
  infoPlist: [
    "BASE_URL": "$(BASE_URL)"
  ],
  dependencies: [
    Project.DomainBusinessOwner,
    Project.MoyaUtil,
    Project.UserSession,
    Project.NetworkImage
  ],
  supportsResources: true
)
