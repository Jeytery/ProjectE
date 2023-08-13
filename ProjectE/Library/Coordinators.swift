//
//  Coordinators.swift
//  ProjectE
//
//  Created by Jeytery on 29.06.2023.
//

import Foundation

public protocol CompletionlessCoordinatable: AnyObject {
    func add(coordinatable: CompletionlessCoordinatable)
    func remove(coordinatable: CompletionlessCoordinatable)

    func start()
    
    var childCoordinators: [CompletionlessCoordinatable] { get set }
}

public extension CompletionlessCoordinatable {
    func add(coordinatable: CompletionlessCoordinatable) {
        guard !childCoordinators.contains(where: {
            $0 === coordinatable
        }) else {
            return
        }
        coordinatable.start()
        childCoordinators.append(coordinatable)
    }
    
    func remove(coordinatable: CompletionlessCoordinatable) {
        if childCoordinators.isEmpty { return }
        if !coordinatable.childCoordinators.isEmpty {
            coordinatable.childCoordinators
                .filter {
                    $0 !== coordinatable
                }
                .forEach {
                    coordinatable.remove(coordinatable: $0)
                }
        }
        for (index, element) in childCoordinators.enumerated() where element === coordinatable {
            childCoordinators.remove(at: index)
            break
        }
    }
}

public typealias DatelessCoordinatable = CompletionlessCoordinatable & DatelessCompletionable
public typealias Coordinatable = CompletionlessCoordinatable & Completionable

public protocol Completionable {
    associatedtype ReturnData
    var completion: ((ReturnData) -> Void)? { get set }
}

public protocol DatelessCompletionable {
    var completion: (() -> Void)? { get set }
}
