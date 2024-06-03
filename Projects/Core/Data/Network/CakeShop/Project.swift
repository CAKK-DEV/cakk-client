import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "NetworkCakeShop",
  infoPlist: [
    "BASE_URL": "$(BASE_URL)"
  ],
  dependencies: [
    .project(target: "DomainCakeShop", path: "../../../Domain/CakeShop"),
    .project(target: "DomainOAuthToken", path: "../../../Domain/OAuthToken")
  ],
  supportsResources: true
)
