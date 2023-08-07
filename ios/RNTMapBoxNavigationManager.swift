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
    override func view() -> UIView! {
        return RNTMapBoxNavigationView()
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
