//
//  AppPackage.swift
//  ProjectE
//
//  Created by Jeytery on 29.06.2023.
//

import Foundation

struct AppPackage: Codable, Hashable {
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    let package: Package
    let id = UUID()
    
    var score: Int
    var isPinned: Bool
    var dateLastOpened: DataValue
    
    var lastGameResults: [GameResult] = []
    var bestResult: GameResult?
    
    mutating func addGameResult(_ gameResult: GameResult) {
        defer {
            lastGameResults.append(gameResult)
            if lastGameResults.count > 10 {
                let _ = lastGameResults.dropLast()
            }
        }
        guard let _bestResult = bestResult else {
            self.bestResult = gameResult
            return
        }
        if gameResult.score > _bestResult.score {
            self.bestResult = gameResult
        }
    }

    enum DataValue: Codable, Comparable {
        case notOpenedYet
        case opened(data: Date)
    }
    
    static func withPackage(_ package: Package) -> AppPackage {
        return AppPackage(package: package, score: 0, isPinned: false, dateLastOpened: .notOpenedYet)
    }
    
    static let mock = AppPackage(
        package: .mock,
        score: 10,
        isPinned: false,
        dateLastOpened: .opened(data: Date())
    )
}
