//
//  PackageGameResultsView.swift
//  ProjectE
//
//  Created by Jeytery on 06.08.2023.
//

import SwiftUI

struct PackageGameResultsView: View {
    init(stateTasks: [StateTask]) {
        self.stateTasks = stateTasks
    }
    
    var body: some View {
        List(
            stateTasks,
            id: \.self
        ) { stateTask in
            switch stateTask {
            case .incorrect(let task, let wrongAnwser):
                VStack(alignment: .leading) {
                    Text(task.data.question)
                        .font(.headline)
                        .foregroundColor(.red)
                    Text("Your answer: " + wrongAnwser)
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Correct: \(task.data.answer)")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                
            case .correct(let task):
                VStack(alignment: .leading) {
                    Text(task.data.question)
                        .font(.headline)
                        .foregroundColor(.green)
                    Text("Correct: \(task.data.answer)")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private let stateTasks: [StateTask]
}

struct PackageGameResultsView_Previews: PreviewProvider {
    static var previews: some View {
        PackageGameResultsView(
            stateTasks: [.correct(.mock), .incorrect(.mock, "worng answer")]
        )
    }
}
