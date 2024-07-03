import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "OAuthToken",
  dependencies: [
    Project.TokenUtil,
    Project.DomainOAuthToken
  ]
)
