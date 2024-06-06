import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "UserDefaultsUserSession",
  dependencies: [
    Project.DomainUser,
    Project.KeyChainOAuthToken
  ]
)
