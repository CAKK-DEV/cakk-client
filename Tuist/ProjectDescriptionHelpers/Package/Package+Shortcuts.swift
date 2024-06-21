import ProjectDescription

public enum External {
  public static var swinject: TargetDependency {
    return .external(name: "Swinject")
  }
  
  public static var lottie: TargetDependency {
    return .external(name: "Lottie")
  }
  
  public static var snapKit: TargetDependency {
    return .external(name: "SnapKit")
  }
  
  public static var haptico: TargetDependency {
    return .external(name: "Haptico")
  }
  
  public static var moya: TargetDependency {
    return .external(name: "Moya")
  }
  
  public static var combineMoya: TargetDependency {
    return .external(name: "CombineMoya")
  }
  
  public static var kakaoSDKCommon: TargetDependency {
    return .external(name: "KakaoSDKCommon")
  }
  
  public static var kakaoSDKAuth: TargetDependency {
    return .external(name: "KakaoSDKAuth")
  }
  
  public static var kakaoSDKUser: TargetDependency {
    return .external(name: "KakaoSDKUser")
  }

  public static var kingfisher: TargetDependency {
    return .external(name: "Kingfisher")
  }
}
