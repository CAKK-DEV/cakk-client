import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "NetworkBusiness",
  infoPlist: [
    "BASE_URL": "$(BASE_URL)"
  ],
  dependencies: [
    Project.DomainBusiness,
    Project.DomainOAuthToken,
    Project.UserSession,
    Project.MoyaUtil,
    External.sdWebImageWebPCoder
  ],
  supportsResources: true
)
