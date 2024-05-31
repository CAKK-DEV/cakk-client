import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "ExampleLogin",
  infoPlist: [
    "UILaunchStoryboardName": "LaunchScreen",
    "BASE_URL": "$(BASE_URL)",
    "GIDClientID": "$(GIDClientID)",
    "KAKAO_SDK_APP_KEY": "$(KAKAO_SDK_APP_KEY)",
    "LSApplicationQueriesSchemes": [
      "kakaokompassauth",
      "kakaolink"
    ],
    "CFBundleURLTypes": [
      [
        "CFBundleTypeRole": "Editor",
        "CFBundleURLSchemes": ["$(GOOGLE_URL_SCHEME)"]
      ],
      [
        "CFBundleTypeRole": "Editor",
        "CFBundleURLSchemes": ["$(KAKAO_URL_SCHEME)"]
      ]
    ]
  ],
  dependencies: [
    .project(target: "DIContainer", path: "../../Shared/DIContainer"),
    .project(target: "FeatureLogin", path: "../Login"),
    .project(target: "OAuthToken", path: "../../Core/Data/Token/OAuthToken")
  ],
  entitlements: "App.entitlements"
)