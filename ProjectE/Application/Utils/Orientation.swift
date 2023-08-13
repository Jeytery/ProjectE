//
//  Orientation.swift
//  ProjectE
//
//  Created by Jeytery on 06.07.2023.
//

import Foundation
import UIKit

struct AppOrientation {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(
        _ orientation: UIInterfaceOrientationMask,
        andRotateTo rotateOrientation: UIInterfaceOrientation
    ) {
   
        self.lockOrientation(orientation)
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}
