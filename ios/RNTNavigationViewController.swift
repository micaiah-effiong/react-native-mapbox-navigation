//
//  RNTNavigationViewController.swift
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
import MapboxDirections


@objc(RNTNavigationViewController)
class RNTNavigationViewController: UIViewController, NavigationViewControllerDelegate, NavigationMapViewDelegate {

    var navigationView: NavigationView!
    var navigationMapView: NavigationMapView!
    private var _navigationViewController: NavigationViewController?
    private var routeColor: UIColor?
    private var isNavigating: Bool = false
    // private var resumeButton = ResumeButton()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView = NavigationView(frame: view.frame)
        navigationMapView = navigationView.navigationMapView
        // navigationView.speedLimitView = SpeedLimitView()
        
        navigationMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        navigationMapView.delegate = self
        navigationMapView.userLocationStyle = .puck2D()
        
        navigationMapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationMapView)

        setUpNavigationView()
        // view.addSubview(resumeButton)

    }
    
    private func setUpNavigationView() {
        NSLayoutConstraint.activate([
            navigationMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationMapView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let navigationViewportDataSource = NavigationViewportDataSource(navigationView.navigationMapView.mapView, viewportDataSourceType: .raw)
        navigationView.navigationMapView.navigationCamera.viewportDataSource = navigationViewportDataSource
        navigationView.navigationMapView.navigationCamera.follow()
        
        // resume button
//        resumeButton.addTarget(self, action: #selector(moveCameraToCenter), for: .touchUpInside)
    }
    
    public func addFloatingNavigationButton(button: UIButton){
        self._navigationViewController?.navigationView.floatingStackView.addArrangedSubview(button)
    }
    
    public func setDefaultRouteColor(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0){
        let _red = CGFloat(red) / 255.0
        let _green = CGFloat(green) / 255.0
        let _blue = CGFloat(blue) / 255.0
        
        self.routeColor = UIColor(red: _red, green: _green, blue: _blue, alpha: alpha)
        // expose this activity to react [SET ROUTE COLOR TRIP]
    }
    
    @objc public func startNavigation(){
        let navigationRouteOptions = NavigationRouteOptions(coordinates: [
            CLLocationCoordinate2D(latitude: 4.824532, longitude: 6.987516),
            CLLocationCoordinate2D(latitude: 4.8237162, longitude: 6.9919064)
        ])
        
        guard !self.isNavigating else { return }
        
        self.isNavigating = true

        // Request a route and present `NavigationViewController`.
        Directions.shared.calculate(navigationRouteOptions) { [weak self] (_, result) in
            switch result {
            case .failure(let error):
                print("Error occured: \(error.localizedDescription)")
            case .success(let routeResponse):
                guard let self = self else { return }

                let navigationService = MapboxNavigationService(indexedRouteResponse: IndexedRouteResponse(routeResponse: routeResponse, routeIndex: 0), credentials: NavigationSettings.shared.directions.credentials, simulating: .always)
               
                let navigationOptions = NavigationOptions(navigationService: navigationService)
                
                let navigationViewController = NavigationViewController(for: IndexedRouteResponse(routeResponse: routeResponse, routeIndex: 0),navigationOptions: navigationOptions)
                
                self._navigationViewController = navigationViewController
                
                navigationViewController.delegate = self
                // addChild(navigationViewController)

                view.addSubview(navigationViewController.view)
                
                if(self.routeColor != nil){
                    navigationViewController.navigationView.navigationMapView.trafficUnknownColor = .systemGreen
                    navigationViewController.navigationView.navigationMapView.trafficLowColor = .systemGreen
                    navigationViewController.navigationView.navigationMapView.routeCasingColor = UIColor(white: 1, alpha: 0.8)
                }
                
                
                // navigationViewController.modalPresentationStyle = .fullScreen
                navigationViewController.routeLineTracksTraversal = true
                navigationViewController.navigationMapView?.localizeLabels()
                navigationViewController.showsEndOfRouteFeedback = true
                navigationViewController.showsReportFeedback = false
                
                navigationViewController.view.translatesAutoresizingMaskIntoConstraints = false

                // Make sure to set `transitioningDelegate` to be a current instance of `ViewController`.
//                navigationViewController.transitioningDelegate = self

                NSLayoutConstraint.activate([
                    navigationViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                    navigationViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                    navigationViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
                    navigationViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
                ])
                self.didMove(toParent: self)
                
                // Make sure to present `NavigationViewController` in animated way.
                // self.present(navigationViewController, animated: true, completion: nil)
            }
        }
    }
    
    /** build and showcase route for navigatoin */
    func previewRoute(){
        
        
        // guard let routes = routeResponse.routes, let route = routeResponse.routes?.first else { return }
        // navigationMapView.show(routes)
        // self.navigationMapView.showWaypoints(on: route)
        // self.navigationMapView.showcase(routes, routesPresentationStyle: .all(shouldFit: true), animated: true)
        
        // return
    }
    
    @objc public func endNavigation() {
        // expose this activity to react via module property [END NAVIGATION]
        
        guard let nVController = self._navigationViewController  else { return }
        
        guard self.isNavigating else { return }
        
        /** Prevent manipulation on application interface outside of main thread */
        DispatchQueue.main.async {
            self._navigationViewController = nil
            
            nVController.navigationService.endNavigation(feedback: nil)
            
            nVController.dismiss(animated: true, completion: {
                let navigationMapView = self.navigationView.navigationMapView
                
                let navigationViewportDataSource = NavigationViewportDataSource(navigationMapView.mapView, viewportDataSourceType: .raw)
                
                navigationMapView.navigationCamera.viewportDataSource = navigationViewportDataSource
                
                /** animate removing navigation view */
                UIView.animate(withDuration: 0.25, animations: {
                    nVController.view.alpha = 0.0
                }, completion: { finished in
                    if finished {
                        nVController.view.removeFromSuperview()
                        nVController.removeFromParent()
                    }
                })
                
                self.isNavigating = false
            })
        }
    }
    
    @objc private func moveCameraToCenter(){
        guard !self.isNavigating else { return }
        
        navigationView.navigationMapView.navigationCamera.follow()
        // navigationView.navigationMapView.navigationCamera.moveToOverview()
    }
    
    @objc func didUpdatePassiveLocation(_ notification: Notification) {
        // RoadName(text: <#T##String#>, language: <#T##String#>)
        // Set the sign standard of the speed limit UI components
        // to the standard posted by PassiveLocationManager
        // speedLimitView.signStandard = notification.userInfo?[PassiveLocationManager.NotificationUserInfoKey.signStandardKey] as? SignStandard
        // Set the value of the speed limit UI component to the value
        // posted by PassiveLocationManager
        // speedLimitView.speedLimit = notification.userInfo?[PassiveLocationManager.NotificationUserInfoKey.speedLimitKey] as? Measurement<UnitSpeed>
    }
    
    public func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
        if(!canceled) {
            return ()
        }
        // expose this activity to react via event [ON CANCEL]
        self.endNavigation()
    }
        
    public func navigationViewController(_ navigationViewController: NavigationViewController, didSubmitArrivalFeedback feedback: EndOfRouteFeedback) {
        print("Feedback comment", feedback.comment ?? "no comment", "Feedback rating", feedback.rating ?? 0.2)
        // expose this activity to react via event [ON FEEDBACK]
    }
    
    func navigationViewController(_ navigationViewController: NavigationViewController, didArriveAt waypoint: Waypoint) {
        // expose this activity to react via event [ON ARRIVE]
        print("ARRIVED =>>>>>>>")
        return ()
    }
}
