//
//  LocationController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 2/7/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import CoreLocation
import OpenInGoogleMaps
import Signals



public class LocationController: NSObject, CLLocationManagerDelegate {
  
  // MARK: Singleton instance
  
  private struct Singleton { static let locationController = LocationController() }
  public class func sharedInstance() -> LocationController { return Singleton.locationController }
  
  // MARK: Model
  private let model = LocationModel()
  
  // MARK: class variables
  
  private var locationManager: CLLocationManager?
  
  public let _didUpdateAuthorizationStatus = Signal<Bool>()
  
  public override init() {
    super.init()
    setupDataBinding()
    setupLocationManager()
    setupMapsLib()
  }
  
  private func setupDataBinding() {
    model._authorizationStatus.removeListener(self)
    model._authorizationStatus.listen(self) { [weak self] status in
      self?._didUpdateAuthorizationStatus.fire(self?.isRegisteredForLocationUpdates() ?? false)
    }
  }
  
  private func setupLocationManager() {
    locationManager = CLLocationManager()
    locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    locationManager?.distanceFilter = kCLDistanceFilterNone
    locationManager?.delegate = self
  }
  
  private func setupMapsLib() {
    OpenInGoogleMapsController.sharedInstance().fallbackStrategy = .AppleMaps
  }
  
  public func getCurrentLocation(execute: CLLocation? -> Void) {
    setupLocationManager()
    locationManager?.requestWhenInUseAuthorization()
    model._userLocation.removeListener(self)
    model._userLocation.listenOnce(self) { [weak self] location in
      execute(location)
      if let strongSelf = self {
        self?.model._userLocation.removeListener(strongSelf)
      }
    }
  }
  
  public func isRegisteredForLocationUpdates() -> Bool {
    switch model.authorizationStatus {
    case .AuthorizedWhenInUse:
      return true
      break
    default:
      return false
    }
  }
  
  public func routeToLocation(location: CLLocation?, host: String? = nil, callback: (() -> Void)) {
    if let location = location {
      getCurrentLocation() { userLocation in
        if let userLocation = userLocation {
          let alertController = UIAlertController(title: host ?? "User's location", message: "\(Int(userLocation.distanceFromLocation(location))) meters away", preferredStyle: .Alert)
          alertController.addAction(UIAlertAction(title: "Open in Maps?", style: UIAlertActionStyle.Default) { action in
            let definition = GoogleMapDefinition()
            definition.queryString = "\(location.coordinate.latitude) \(location.coordinate.longitude)"
            OpenInGoogleMapsController.sharedInstance().openMap(definition)
          })
          alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
          })
          UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        }
        callback()
      }
      if model.authorizationStatus == .Denied {
        showPermissions()
      }
    }
  }
  
  public func showPermissions() {
    
    
    if CLLocationManager.authorizationStatus().rawValue == 0 {
      setupLocationManager()
      locationManager?.requestWhenInUseAuthorization()
    } else if CLLocationManager.authorizationStatus().rawValue > 0 {
      let alertController = UIAlertController(title: "Permissions", message: "We use your location to help you meet up with potential buyers/sellers! As well as making it easier for us to find matches for you!", preferredStyle: .Alert)
      alertController.addAction(UIAlertAction(title: "Open app settings", style: UIAlertActionStyle.Default) { action in
        NSTimer.after(0.2) {
          if let nsurl = NSURL(string: UIApplicationOpenSettingsURLString) { UIApplication.sharedApplication().openURL(nsurl) }
        }
      })
      alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
        })
      UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
  }
  
  public func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    model.userLocation = newLocation
  }
  
  public func getAddressString(location: CLLocation?, callback: String -> Void) {
    if let location = location {
      CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
        if let placemark = placemarks?.first { callback("\(placemark.locality ?? ""), \(placemark.administrativeArea ?? "") \(placemark.country ?? ""), \(placemark.postalCode ?? "")") }
      }
    }
  }
  
  public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    
    model.authorizationStatus = status
    
    switch status {
    case .AuthorizedWhenInUse:
      locationManager?.startUpdatingLocation()
      break
    default:
      locationManager?.stopUpdatingLocation()
      break
    }
  }
}