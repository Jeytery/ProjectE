    //
//  PackageGameView.swift
//  ProjectE
//
//  Created by Jeytery on 06.07.2023.
//

import SwiftUI

enum PackageGameViewViewState {
    case numberCounter
    case taskGameplay(Task)
    case finished([StateTask])
}

fileprivate final class PackageGameViewViewModel: ObservableObject {
    @Published var viewState: PackageGameViewViewState = .numberCounter
}

struct PackageGameView: View {
    
    enum EventOutput {
        case taskBecameStatefull(StateTask)
        case gameFinished
    }
    
    var eventOutput: (EventOutput) -> Void
    
    init(
        firstTask: Task,
        extraAnswerTime: Int,
        eventOutput: @escaping (EventOutput) -> Void
    ) {
        self.firstTask = firstTask
        self.extraAnswerTime = extraAnswerTime
        self.eventOutput = eventOutput
    }
    
    var body: some View {
        content(state: viewModel.viewState)
    }
    
    @ObservedObject
    private var viewModel = PackageGameViewViewModel()

    private let extraAnswerTime: Int
    private let firstTask: Task
    private let gameStartTime = 3
}

private extension PackageGameView {
    func content(state: PackageGameViewViewState) -> some View {
        switch state {
        case .numberCounter:
            // all this staff to initialize keyboard buttons
            let view = PackageGameCounterView(maxValue: gameStartTime) {
                viewModel.viewState = .taskGameplay(self.firstTask)
            }
            return AnyView(view)
            
        case .taskGameplay(let task):
            let view = ScrollView {
                PackageGameTaskView(
                    task: task,
                    vm: .init(timeRemaining: task.answerTime, extraAnswerTime: extraAnswerTime)
                ) {
                    event in
                    switch event {
                    case .taskBecameStatefull(let stateTask):
                        self.eventOutput(.taskBecameStatefull(stateTask))
                    }
                }
                
            }
            
            
                
            return AnyView(view)
            
        case .finished(let stateTasks):
            let view = PackageGameResultsView(stateTasks: stateTasks)
            eventOutput(.gameFinished)
            return AnyView(view)
        }
    }
}

extension PackageGameView {
    func setState(_ state: PackageGameViewViewState) {
        self.viewModel.viewState = state
    }
}

struct PackageGameView_Previews: PreviewProvider {
    static var previews: some View {
        PackageGameView.init(firstTask: .mock, extraAnswerTime: 0) { _ in }
    }
}
