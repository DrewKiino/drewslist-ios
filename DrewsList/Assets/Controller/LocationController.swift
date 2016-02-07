//
//  LocationController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 2/7/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import CoreLocation

public class LocationController: NSObject, CLLocationManagerDelegate {
  
  // MARK: Singleton instance
  
  private struct Singleton { static let locationController = LocationController() }
  public class func sharedInstanced() -> LocationController { return Singleton.locationController }
  
  // MARK: Model
  private let model = LocationModel()
  
  // MARK: Singleton instances
  
  private let permissionController = PermissionsController.sharedInstance()
  
  // MARK: class variables
  
  private var locationManager: CLLocationManager?
  
  public override init() {
    super.init()
    setupSelf()
  }
  
  private func setupSelf() {
    locationManager = CLLocationManager()
    locationManager?.delegate = self
    
  }
  
  public func getLocation() {
    locationManager?.requestWhenInUseAuthorization()
  }
  
  public func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    model.userLocation = newLocation
  }
  
  public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
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