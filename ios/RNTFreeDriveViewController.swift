//
//  RNTFreeDriveViewController.swift
//  MapboxNavigation
//
//  Created by Micah Effiong on 8/8/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import UIKit
import MapboxNavigation
import MapboxCoreNavigation
import MapboxMaps
//import MapboxDirections

@objc(RNTFreeDriveViewController)
class RNTFreeDriveViewController: UIViewController {
    
    private lazy var navigationMapView = NavigationMapView()
    private let passiveLocationManager = PassiveLocationManager()
    private lazy var passiveLocationProvider = PassiveLocationProvider(locationManager: passiveLocationManager)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationMapView()
        
        let locationProvider: LocationProvider = passiveLocationProvider
        navigationMapView.mapView.location.overrideLocationProvider(with: locationProvider)
        passiveLocationProvider.startUpdatingLocation()
    }
    
    private func setupNavigationMapView() {
        navigationMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationMapView.userLocationStyle = .puck2D()
        
        let navigationViewportDataSource = NavigationViewportDataSource(navigationMapView.mapView)
        navigationViewportDataSource.options.followingCameraOptions.zoomUpdatesAllowed = false
        navigationViewportDataSource.followingMobileCamera.zoom = 17.0
        navigationMapView.navigationCamera.viewportDataSource = navigationViewportDataSource
        view.addSubview(navigationMapView)
    }
}
