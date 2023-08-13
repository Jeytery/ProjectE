//
//  MainCoordinator.swift
//  ProjectE
//
//  Created by Jeytery on 29.06.2023.
//

import Foundation
import UIKit
import SwiftUI
import AlertKit

class MainCoordinator: CompletionlessCoordinatable {
    var childCoordinators: [CompletionlessCoordinatable] = []
    
    func start() {
        self.splitViewController.delegate = self
        
        self.menuView = MenuView()
        menuView.outputEventHandler = menuViewDidGetEvent
        
        let hosting = UIHostingController(rootView: menuView)
        mainNavigationController.setViewControllers([hosting], animated: false)
        let contentViewController = UINavigationController(rootViewController: UIHostingController(rootView: ContentView()))
        self.splitViewController.viewControllers = [mainNavigationController, contentViewController]
        self.splitViewController.preferredDisplayMode = .oneBesideSecondary
    }
    
    private var menuView: MenuView!
    private let mainNavigationController = UINavigationController()
    private(set) var splitViewController = UISplitViewController()
    
    private var storeCoordinator: StoreCoordinator!
    private var packageBoardCoordinator: PackageBoardCoordinator!
}

private extension MainCoordinator {
    func showGame(package: AppPackage) {
        let packageGameCoordinator = PackageGameCoordinator(
            appPackage: package,
            previousViewController: splitViewController)
        self.add(coordinatable: packageGameCoordinator)
        packageGameCoordinator.eventOutputHandler = {
            switch $0 {
            case .finished(let gameResult):
                self.packageBoardCoordinator.saveGameResult(gameResult)
                self.menuView.updatePackage(self.packageBoardCoordinator.appPackage)
                
            default: break
            }
        }
    }
    
    func showStore() {
        self.storeCoordinator = StoreCoordinator()
        storeCoordinator.eventOutputHandler = { [self] event in
            switch event {
            case .addedPackage(let package):
                self.menuView.addPackage(package)
                storeCoordinator.navigationController.popToRootViewController(animated: false)
                mainNavigationController.popViewController(animated: true)
                let contentViewController = UINavigationController(rootViewController: UIHostingController(rootView: ContentView()))
                self.splitViewController.viewControllers = [mainNavigationController, contentViewController]
                AlertKitAPI.present(
                    title: "Added to library",
                    icon: .done,
                    style: .iOS17AppleMusic,
                    haptic: .success
                )
                
            case .addedPackages(let packages):
                self.menuView.addPackages(packages)
            }
        }
        self.add(coordinatable: storeCoordinator)
        self.splitViewController.showDetailViewController(storeCoordinator.navigationController, sender: nil)
    }
    
    func showPackageBoard(appPackage: AppPackage) {
        self.packageBoardCoordinator = PackageBoardCoordinator(appPackage: appPackage) // late init 
        packageBoardCoordinator.eventOutputHandler = { [self] event in
            switch event {
            case .pinnedPackage(let appPackage):
                self.menuView.updatePackage(appPackage)
                AlertKitAPI.present(
                    title: appPackage.isPinned ? "Pinned" : "Unpinned",
                    icon: .done,
                    style: .iOS17AppleMusic,
                    haptic: .success
                )
            case .startPackage(let package):
                self.showGame(package: package)
            }
        }
        self.add(coordinatable: packageBoardCoordinator)
        self.splitViewController.showDetailViewController(packageBoardCoordinator.navigationController, sender: nil)
    }
    
    func menuViewDidGetEvent(_ event: MenuView.OutputEvent) {
        switch event {
        case .finished: break // imposible case
        case .tapSettings:
            let viewController = UIHostingController(rootView: SettingsView())
            mainNavigationController.pushViewController(viewController, animated: true)
        case .tapDiscover: showStore()
        case .choosedPackage(let appPackage): showPackageBoard(appPackage: appPackage)
        }
    }
}
 
extension MainCoordinator: UISplitViewControllerDelegate {
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        return true
    }
}
