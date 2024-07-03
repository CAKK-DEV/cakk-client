import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "UserSession",
  dependencies: [
    Project.DomainUser,
    Project.KeyChainOAuthToken
  ]
)
