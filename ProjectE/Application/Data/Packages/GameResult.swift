//
//  GameResult.swift
//  ProjectE
//
//  Created by Dmytro Ostapchenko on 10.07.2023.
//

import Foundation

enum StateTask: Equatable, Hashable, Codable {
    
    case correct(Task)
    
    // task, wrong answer
    case incorrect(Task, String)
}

struct GameResult: Codable, Equatable, Hashable {
    let stateTasks: [StateTask]
    
    var score: Int {
        return self.stateTasks
            .map {
                switch $0 {
                case .correct(let task):
                    return task.answerMark ?? 0
                default: return 0
                }
            }
            .reduce(0, +)
    }
}
