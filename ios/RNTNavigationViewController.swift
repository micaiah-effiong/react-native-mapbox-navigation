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
class RNTNavigationViewController: UIViewController, NavigationViewControllerDelegate {

    var navigationView: NavigationView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView = NavigationView(frame: view.frame)
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationView)

        NSLayoutConstraint.activate([
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let navigationViewportDataSource = NavigationViewportDataSource(navigationView.navigationMapView.mapView,
                                                                       viewportDataSourceType: .raw)
        navigationView.navigationMapView.navigationCamera.viewportDataSource = navigationViewportDataSource
        navigationView.navigationMapView.navigationCamera.follow()

        let navigationRouteOptions = NavigationRouteOptions(coordinates: [
            CLLocationCoordinate2D(latitude: 37.77766, longitude: -122.43199),
            CLLocationCoordinate2D(latitude: 37.77536, longitude: -122.43494)
        ])

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
                
                navigationViewController.delegate = self
                addChild(navigationViewController)
                view.addSubview(navigationViewController.view)
                
//                navigationViewController.modalPresentationStyle = .fullScreen
                navigationViewController.routeLineTracksTraversal = true
                navigationViewController.navigationMapView?.localizeLabels()
                
                
                navigationViewController.view.backgroundColor = .gray
                navigationViewController.view.translatesAutoresizingMaskIntoConstraints = false

                // Make sure to set `transitioningDelegate` to be a current instance of `ViewController`.
                navigationViewController.transitioningDelegate = self
//
                // Make sure to present `NavigationViewController` in animated way.
                
                NSLayoutConstraint.activate([
                    navigationViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                    navigationViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                    navigationViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
                    navigationViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
                ])
                self.didMove(toParent: self)
                
//                self.present(navigationViewController, animated: true, completion: nil)
            }
        }
    }
}

// Transition that is used for `NavigationViewController` presentation.
class PresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {

   func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
       return 0.0
   }

   func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
       guard let fromViewController = transitionContext.viewController(forKey: .from) as? RNTNavigationViewController,
             let toViewController = transitionContext.viewController(forKey: .to) as? NavigationViewController else {
           transitionContext.completeTransition(false)
           return
       }

       // Re-use `NavigationMapView` instance in `NavigationViewController`.
       toViewController.navigationMapView = fromViewController.navigationView.navigationMapView

       transitionContext.containerView.addSubview(toViewController.view)
       transitionContext.completeTransition(true)
   }
}

// Transition that is used for `NavigationViewController` dismissal.
class DismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {

   func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
       return 0.0
   }

   func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
       guard let fromViewController = transitionContext.viewController(forKey: .from) as? NavigationViewController,
             let navigationMapView = fromViewController.navigationMapView,
             let toViewController = transitionContext.viewController(forKey: .to) as? RNTNavigationViewController else {
           transitionContext.completeTransition(false)
           return
       }

       // Inject `NavigationMapView` instance that was previously used by `NavigationViewController` back to
       // `ViewController`.
       toViewController.navigationView.navigationMapView = navigationMapView

       transitionContext.containerView.addSubview(toViewController.view)
       transitionContext.completeTransition(true)
   }
}

extension RNTNavigationViewController: UIViewControllerTransitioningDelegate {

   public func animationController(forPresented presented: UIViewController,
                                   presenting: UIViewController,
                                   source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       return PresentationTransition()
   }

   public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       return DismissalTransition()
   }
}
