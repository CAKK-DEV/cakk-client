// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
  productTypes: [
    "Lottie": .framework,
    "SnapKit": .framework,
    "Haptico": .framework,
    "Moya": .framework,
    "CombineMoya": .framework,
    "Swinject": .framework,
    "Kingfisher": .framework,
    "SDWebImageWebPCoder": .framework
  ],
  baseSettings: .settings(
    configurations: [
      .build(.stub),
      .build(.prod),
      .build(.release)
    ]
  )
)
#endif

let package = Package(
  name: "Dependencies",
  dependencies: [
    .package(url: "https://github.com/airbnb/lottie-ios", from: "4.4.3"),
    .package(url: "https://github.com/SnapKit/SnapKit", from: "5.7.1"),
    .package(url: "https://github.com/iSapozhnik/Haptico", from: "1.0.1"),
    .package(url: "https://github.com/Moya/Moya", from: "15.0.3"),
    .package(url: "https://github.com/kakao/kakao-ios-sdk", from: "2.22.2"),
    .package(url: "https://github.com/Swinject/Swinject", from: "2.8.8"),
    .package(url: "https://github.com/onevcat/Kingfisher", from: "7.12.0"),
    .package(url: "https://github.com/SDWebImage/SDWebImageWebPCoder.git", from: "0.14.6")
  ]
)
