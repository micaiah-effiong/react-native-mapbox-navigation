//
//  RNTMapBoxNavigationView.swift
//  MapboxNavigation
//
//  Created by Micah Effiong on 8/7/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import UIKit


@objc(RNTMapBoxNavigationView)
class RNTMapBoxNavigationView: UIView {
    @objc let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
    
    // @objc let freeDriveViewController: UIViewController = RNTFreeDriveViewController()
    @objc let navigationViewController = RNTNavigationViewController()
    
    override init(frame: CGRect) {
        // make navigation view fit parent frame in embeded navigation
        navigationViewController.view.frame = frame
        super.init(frame: frame)
        
        label.backgroundColor = UIColor.purple
        label.textColor = UIColor.orange
        label.text = "High Score: 200"
        label.textAlignment = .center
        // for debug purpose only
        // self.addSubview(label)
        
        
        self.addSubview(navigationViewController.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    @objc func startNavigation(){
//        parentvc
//        print("startNavigaton ===>>")
//    }
}
