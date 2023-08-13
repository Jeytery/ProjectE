//
//  AppDelegate.swift
//  ProjectE
//
//  Created by Jeytery on 29.06.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all
    
    private let mainCoordinator = MainCoordinator()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        mainCoordinator.start()
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = mainCoordinator.splitViewController
        window!.makeKeyAndVisible()
        
        if
            UIDevice.current.userInterfaceIdiom == .phone,
            UIScreen.main.bounds.height < 932,
            UIDevice.current.orientation == .portrait,
            UIDevice.current.orientation == .portraitUpsideDown
        {
            AppOrientation.lockOrientation(.portrait)
        }
        else if
            UIDevice.current.userInterfaceIdiom == .phone,
            UIScreen.main.bounds.height < 430,
            UIDevice.current.orientation == .landscapeRight,
            UIDevice.current.orientation == .landscapeLeft
        {
            AppOrientation.lockOrientation(.portrait)
        }
        
        return true
    }
   
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
}

