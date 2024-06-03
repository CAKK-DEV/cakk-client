import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "OAuthToken",
  dependencies: [
    .project(target: "TokenUtil", path: "../../../../Shared/Util/TokenUtil"),
    .project(target: "DomainOAuthToken", path: "../../../Domain/OAuthToken")
  ]
)
