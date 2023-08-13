//
//  StoreCoordinator.swift
//  ProjectE
//
//  Created by Jeytery on 02.07.2023.
//

import Foundation
import UIKit
import SwiftUI

class StoreCoordinator: CompletionlessCoordinatable {
    enum EventOutput {
        case addedPackage(AppPackage)
        case addedPackages([AppPackage])
    }
    
    var eventOutputHandler: ((EventOutput) -> Void)?
    var childCoordinators: [CompletionlessCoordinatable] = []
    
    func start() {
        var storeView = StoreView()
        storeView.outputEventHandler = self.storeViewDidGetEvent
        let hosting = UIHostingController(rootView: storeView)
        navigationController.pushViewController(
            hosting,
            animated: false
        )
    }
    
    private(set) var navigationController = UINavigationController()
}
 
private extension StoreCoordinator {
    func packageInfoDidGetEvent(_ event: PackageInfoView.ViewEvent) {
        switch event {
        case .tapedAddPackage(let package):
            eventOutputHandler?(.addedPackage(package))
        }
    }
    
    func storeViewDidGetEvent(_ event: StoreView.ViewEvent) {
        switch event {
        case .copiedPackages(let packages):
            self.eventOutputHandler?(.addedPackages(packages))
        case .choosedPackage(let package):
            var packageInfoView = PackageInfoView(appPackage: package)
            packageInfoView.eventOutputHandler = packageInfoDidGetEvent
            self.navigationController.pushViewController(
                UIHostingController(rootView: packageInfoView),
                animated: true
            )
        }
    }
}
