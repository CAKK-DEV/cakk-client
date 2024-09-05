import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "OAuthToken",
  dependencies: [
    Project.Shared,
    Project.DomainOAuthToken
  ]
)
