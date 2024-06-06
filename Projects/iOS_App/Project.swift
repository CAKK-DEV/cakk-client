import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "CAKK",
  infoPlist: [
    "CFBundleShortVersionString": "2.0.0",
    "CFBundleVersion": "1",
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
    Project.DIContainer,
    Project.FeatureUser,
    Project.FeatureOnboarding,
    Project.KeyChainOAuthToken,
    Project.UserDefaultsUserSession
  ],
  entitlements: "App.entitlements"
)
