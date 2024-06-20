import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "NetworkUser",
  dependencies: [
    Project.DomainUser,
    Project.MoyaUtil,
    Project.UserSession,
    .package(product: "SDWebImageWebPCoder")
  ],
  supportsResources: true,
  packages: [
    .remote(url: "https://github.com/SDWebImage/SDWebImageWebPCoder.git", requirement: .upToNextMajor(from: "0.14.6"))
  ]
)
