//
//  Package.swift
//  ProjectE
//
//  Created by Jeytery on 29.06.2023.
//

import Foundation

struct Package: Codable, Identifiable, Hashable {
    static func == (lhs: Package, rhs: Package) -> Bool {
        return lhs.id == rhs.id
    }
   
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    let tasks: [Task]
    
    let duration: Int
    let answerTime: Int
    let answerMark: Int
    
    let scoreTables: [ScoreTable]
    
    let name: String
    
    let gameTaskCount: Int?
    
    let id = UUID()
    
    static let empty = Package(
        tasks: [],
        duration: 0,
        answerTime: 0,
        answerMark: 0,
        scoreTables: [
            .init(score: 100, name: "bronze"),
            .init(score: 200, name: "silver"),
            .init(score: 300, name: "gold")
        ],
        name: "empty package",
        gameTaskCount: nil)
    
    static let mock = Package(
        tasks: [
            .init(data: .init(question: "How are you", words: ["how", "are", "you"], answer: ""), answerTime: nil, answerMark: nil),
            .init(data: .init(question: "How are you", words: ["bronze", "bronze", "bronze"], answer: ""), answerTime: nil, answerMark: nil),
            .init(data: .init(question: "How are you", words: ["bronze", "bronze", "bronze"], answer: ""), answerTime: nil, answerMark: nil)
        ],
        duration: 60,
        answerTime: 10,
        answerMark: 10,
        scoreTables: [
            .init(score: 100, name: "bronze"),
            .init(score: 200, name: "silver"),
            .init(score: 300, name: "gold")
        ],
        name: "Mock Package",
        gameTaskCount: nil)
}

struct ScoreTable: Codable, Hashable {
    let score: Int
    let name: String
}

struct Task: Codable, Hashable {
    func hash(into hasher: inout Hasher) {
        return hasher.combine(uuid)
    }
    
    let uuid = UUID()
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    let data: TaskData
    
    let answerTime: Int?
    let answerMark: Int?
    
    static let mock = Task(data: .init(question: "How are you?", words: ["I", "am", "fine"], answer: "I am fine"), answerTime: nil, answerMark: nil)
}

struct TaskData: Codable {
    let question: String
    let words: [String]
    let answer: String
}
