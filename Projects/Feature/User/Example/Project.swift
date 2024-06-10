import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "ExampleUser",
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
    Project.FeatureUser,
    Project.KeyChainOAuthToken,
    Project.NetworkUser,
    Project.UserSession,
    External.swinject
  ],
  entitlements: "App.entitlements"
)
