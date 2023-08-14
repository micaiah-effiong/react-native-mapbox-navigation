//
//  RNTMapBoxNavigationManager.swift
//  MapboxNavigation
//
//  Created by Micah Effiong on 8/7/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation

@objc(RNTMapBoxNavigationManager)
class RNTMapBoxNavigationManager: RCTViewManager {
    @objc let navView = RNTMapBoxNavigationView()
    
    override func view() -> UIView! {
        return navView
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    
    // Mapbox navigation functions
    @objc func startNavigation(){
        navView.navigationViewController.startNavigation()
    }
    
    @objc func endNavigation(){
        navView.navigationViewController.endNavigation()
    }
}
