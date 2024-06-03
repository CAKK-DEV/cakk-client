import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "NetworkUser",
  dependencies: [
    .project(target: "DomainUser", path: "../../../Domain/User"),
    .project(target: "DomainOAuthToken", path: "../../../Domain/OAuthToken"),
    .project(target: "MoyaUtil", path: "../../../../Shared/MoyaUtil")
  ]
)
