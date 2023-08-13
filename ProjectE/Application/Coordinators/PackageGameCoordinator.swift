//
//  PackageGameCoordinator.swift
//  ProjectE
//
//  Created by Jeytery on 03.07.2023.
//

import Foundation
import UIKit
import SwiftUI

class PackageGameCoordinator: CompletionlessCoordinatable {
    enum EventOutput {
        case pinnedPackage(AppPackage)
        case finished(GameResult)
    }

    var eventOutputHandler: ((EventOutput) -> Void)?
    var childCoordinators: [CompletionlessCoordinatable] = []

    init(appPackage: AppPackage, previousViewController: UIViewController) {
        self.appPackage = appPackage
        self.previousViewController = previousViewController
        self.shuffledTasks = appPackage.package.tasks.shuffled()
    }

    func start() {
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .overCurrentContext
        previousViewController.present(navigationController, animated: true)

        navigationController.closeActionHandler = { [weak self] in
            guard let self = self else { return }
            if !self.isGameFinished { return }
            self.eventOutputHandler?(
                .finished(.init(stateTasks: self.stateTasks))
            )
        }

        if let firstTask = shuffledTasks.first {
            self.packageGameView = PackageGameView(
                firstTask: firstTask,
                extraAnswerTime: appPackage.package.answerTime,
                eventOutput: { [self] event in
                    switch event {
                    case .taskBecameStatefull(let stateTask):
                        if let gameTaskCount = appPackage.package.gameTaskCount, gameTaskCount == self.counter {
                            self.packageGameView.setState(
                                .finished(self.stateTasks)
                            )
                            return
                        }

                        self.counter += 1 // [!] state
                        self.stateTasks.append(stateTask) // [!] state

                        if counter == appPackage.package.tasks.count {
                            self.packageGameView.setState(
                                .finished(self.stateTasks)
                            )
                            return
                        }
                        self.packageGameView.setState(
                            .taskGameplay(shuffledTasks[counter])
                        )
                    case .gameFinished:
                        self.isGameFinished = true // [!] state
                    }
                }
            )

            navigationController.pushViewController(
                UIHostingController(rootView: packageGameView),
                animated: false
            )
        }
        else {
            // show error
        }
    }

    // @State variable //
    private var counter: Int = 0
    private var stateTasks: [StateTask] = []
    private var isGameFinished: Bool = false

    // late init
    private var packageGameView: PackageGameView!

    // consts
    private let appPackage: AppPackage
    private let previousViewController: UIViewController
    private let navigationController = ClosableNavigationController().onlyFirst()
    private let shuffledTasks: [Task]
}

private extension PackageGameCoordinator {
    func initializeMainNavigationController() {
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .overFullScreen
        previousViewController.present(navigationController, animated: false)
    }

    func getGameConterViewController(didEnd: @escaping () -> Void) -> UIViewController {
        let view = PackageGameCounterView(maxValue: 3, completion: {
            didEnd()
        })
        let hosting = UIHostingController(rootView: view)
        hosting.modalTransitionStyle = .crossDissolve
        hosting.modalPresentationStyle = .overFullScreen
        return hosting
    }
}
