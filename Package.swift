// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
  productTypes: [
    "Lottie": .staticFramework,
    "SnapKit": .framework,
    "Haptico": .staticFramework,
    "Moya": .framework,
    "CombineMoya": .framework,
    "Swinject": .framework,
    "Kingfisher": .framework,
    "ExpandableText": .framework,
    "GoogleMobileAds": .framework,
    "PopupView": .framework,
    "KakaoSDKCommon": .framework,
    "KakaoSDKAuth": .framework,
    "KakaoSDKShare": .framework,
    "KakaoSDKUser": .framework,
    "Alamofire": .framework,
    "LinkNavigator": .framework
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
    .package(url: "https://github.com/n3d1117/ExpandableText.git", from: "1.0.0"),
    .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "11.7.0"),
    .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.1.0"),
    .package(url: "https://github.com/exyte/PopupView", from: "3.0.5"),
    .package(url: "https://github.com/Alamofire/Alamofire", from: "5.9.1"),
    .package(url: "https://github.com/forXifLess/LinkNavigator", from: "1.2.6")
    .package(url: "https://github.com/forXifLess/LinkNavigator", from: "1.2.6"),
  ]
)
