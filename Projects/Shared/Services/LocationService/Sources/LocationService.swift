import Foundation
import CoreLocation
import Combine

public class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
  
  // MARK: - Properties
  
  public static let shared = LocationService()
  
  /// 기본값은 서울 강남구입니다.
  public static let defaultCoordinates: (latitude: Double, longitude: Double) = (37.4979, 127.0276)
  
  private let locationManager = CLLocationManager()
  
  @Published public var authorizationStatus: CLAuthorizationStatus
  @Published public var lastLocation: CLLocation?
  
  
  // MARK: - Initializers
  
  private override init() {
    self.authorizationStatus = locationManager.authorizationStatus
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  
  // MARK: - Public Methods
  
  public func requestLocationPermission() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  public func startUpdatingLocation() {
    locationManager.startUpdatingLocation()
  }
  
  public func stopUpdatingLocation() {
    locationManager.stopUpdatingLocation()
  }
  
  public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    DispatchQueue.main.async {
      self.authorizationStatus = status
    }
  }
  
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      DispatchQueue.main.async {
        self.lastLocation = location
      }
    }
  }
  
  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to get user's location: \(error.localizedDescription)")
  }
  
  
  public var latitude: Double {
    self.lastLocation?.coordinate.latitude ?? Self.defaultCoordinates.latitude
  }
  
  public var longitude: Double {
    self.lastLocation?.coordinate.longitude ?? Self.defaultCoordinates.longitude
  }
  
  public var userLocation: CLLocationCoordinate2D? {
    return locationManager.location?.coordinate
  }
}
