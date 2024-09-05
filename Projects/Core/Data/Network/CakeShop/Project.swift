import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "NetworkCakeShop",
  infoPlist: [
    "BASE_URL": "$(BASE_URL)"
  ],
  dependencies: [
    Project.Shared,
    Project.DomainCakeShop,
    Project.DomainOAuthToken,
    Project.UserSession,
    Project.NetworkImage,
  ],
  supportsResources: true
)
