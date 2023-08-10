//
//  RNTNavigationView.swift
//  MapboxNavigation
//
//  Created by Micah Effiong on 8/9/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

//// // adapted from https://pspdfkit.com/blog/2017/native-view-controllers-and-react-native/ and https://github.com/mslabenyak/react-native-mapbox-navigation/blob/master/ios/Mapbox/MapboxNavigationView.swift
//extension UIView {
//  var parentViewController: UIViewController? {
//    var parentResponder: UIResponder? = self
//    while parentResponder != nil {
//      parentResponder = parentResponder!.next
//      if let viewController = parentResponder as? UIViewController {
//        return viewController
//      }
//    }
//    return nil
//  }
//}

@objc(RNTNavigationView)
class RNTNavigationView: UIView, NavigationViewControllerDelegate {
    
    let navigationMapView: NavigationView!
    @objc let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
//    @objc let navViewController: NavigationViewController?
    
    override init(frame: CGRect){
        navigationMapView = NavigationView(frame: frame)
        super.init(frame: frame)
        
        
        
//        navViewController = NavigationViewController(navigationService: <#NavigationService#>)
        
        
        label.text = " See me"
        label.backgroundColor  = .black
        label.textColor = .white
        
        self.addSubview(label)
        self.addSubview(navigationMapView)
        startNavigation()
    }
    
    func startNavigation(){
        var options = NavigationRouteOptions(coordinates: [CLLocationCoordinate2DMake(37.77440680146262, -122.43539772352648), CLLocationCoordinate2DMake(37.76556957793795, -122.42409811526268)], profileIdentifier: .automobile)
        

        Directions.shared.calculate(options) { [weak self] (_, result) in
            
            
            switch result {
            case .failure(let _):
//                strongSelf.onError!(["message": error.localizedDescription])
                return
            case .success(let response):
                guard let strongSelf = self else {
                    return
                }
                
                let navigationService = MapboxNavigationService(routeResponse: response, routeIndex: 0, routeOptions: options, simulating: true ? .always : .never)
                
                let navigationOptions = NavigationOptions(navigationService: navigationService)
//                let vc = NavigationViewController(navigationService: navigationService)
                
//                vc.showsEndOfRouteFeedback = strongSelf.showsEndOfRouteFeedback
//                StatusView.appearance().isHidden = strongSelf.hideStatusView
                
                NavigationSettings.shared.voiceMuted = true//strongSelf.mute;
                let navigationViewController = NavigationViewController(navigationService: navigationService)
                
                navigationViewController.modalPresentationStyle = .fullScreen
                // Render part of the route that has been traversed with full transparency, to give the illusion of a disappearing route.
                navigationViewController.delegate = strongSelf
                
                
                navigationViewController.routeLineTracksTraversal = true
                let applicationVC = UIApplication.shared.delegate?.window??.rootViewController
                
                applicationVC?.addChild(navigationViewController)
                    strongSelf.navigationMapView.addSubview(navigationViewController.view)
//                strongSelf.present(navigationViewController, animated: true, completion: nil)
                applicationVC?.didMove(toParent: applicationVC)
                
//                parentVC.addChild(vc)
                strongSelf.addSubview(navigationViewController.view)
                navigationViewController.view.frame = strongSelf.bounds
//                navigationViewController.didMove(toParent: parentVC)
//                strongSelf.navViewController = vc
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}
