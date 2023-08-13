//
//  PackageBoardCoordinator.swift
//  ProjectE
//
//  Created by Jeytery on 03.07.2023.
//

import Foundation
import UIKit
import SwiftUI

class PackageBoardCoordinator: CompletionlessCoordinatable {
    enum EventOutput {
        case pinnedPackage(AppPackage)
        case startPackage(AppPackage)
    }
    
    var eventOutputHandler: ((EventOutput) -> Void)?
    var childCoordinators: [CompletionlessCoordinatable] = []
    
    init(appPackage: AppPackage) {
        self.appPackage = appPackage
    }
    
    func start() {
        var packageBoardView = PackageBoardView(appPackage: appPackage)
        packageBoardView.eventOutputHandler = { event in
            switch event {
            case .pinnedPackage(let package):
                self.eventOutputHandler?(.pinnedPackage(package))
            case .startPackage(let package):
                self.eventOutputHandler?(.startPackage(package))
            case .tapGameResult(let gameResult):
                let hosting = UIHostingController(rootView: PackageGameResultsView(stateTasks: gameResult.stateTasks))
                self.navigationController.pushViewController(hosting, animated: true)
            }
        }
        let hosting = UIHostingController(rootView: packageBoardView)
        navigationController.viewControllers = [hosting]
    }
    
    private(set) var navigationController = UINavigationController()
    private(set) var appPackage: AppPackage
}

extension PackageBoardCoordinator {
    func saveGameResult(_ gameResult: GameResult) {
        appPackage.addGameResult(gameResult)
        self.start()
    }
}
