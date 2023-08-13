//
//  PackageGameTaskView.swift
//  ProjectE
//
//  Created by Jeytery on 06.07.2023.
//

import SwiftUI

class PackageGameTaskViewViewModel2: ObservableObject {
    init(timeRemaining: Int?, extraAnswerTime: Int) {
        self.textFieldText = ""
        self.timeRemaining = timeRemaining ?? extraAnswerTime
    }

    @Published var textFieldText: String
    @Published var timeRemaining: Int
}

struct PackageGameTaskView: View {

    enum OutputEvent {
        case taskBecameStatefull(StateTask)
    }

    var outputHandler: (OutputEvent) -> Void

    init(
        task: Task,
        vm: PackageGameTaskViewViewModel2,
        outputHandler: @escaping (OutputEvent) -> Void
    ) {
        self.task = task
        self.outputHandler = outputHandler
        self.viewModel2 = PackageGameTaskViewViewModel2(timeRemaining: task.answerTime, extraAnswerTime: 0)
        self.viewModel2.textFieldText = ""
    }

    var body: some View {
        QuestionBody(task: task)
    }

    private let task: Task

    @FocusState
    private var isKeyboardFocused: Bool

    @ObservedObject
    private var viewModel2: PackageGameTaskViewViewModel2

    private let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
}

private extension PackageGameTaskView {
    func QuestionBody(task: Task) -> some View {
        VStack {
            VStack {
                Spacer()
                    .frame(height: 10)
                _TimerView()
                    .frame(width: 75, height: 30, alignment: .center)

                Text(task.data.question)
                    .foregroundColor(.blue)
                    .font(.system(size: 22, weight: .semibold, design: .default))
                    .multilineTextAlignment(.center)
            }

            VStack {
                TextField("Enter answer", text: $viewModel2.textFieldText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isKeyboardFocused)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isKeyboardFocused = true
                        }
                    }
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                    .padding([.leading, .trailing], 12)
                FlexibleGamePanelView(
                    strings: task.data.words,
                    input: $viewModel2.textFieldText,
                    eventOutputHandler: {
                        event in
                        self.packageGamePanelGetEvent(event)
                    })
                .frame(height: 100)
                .padding([.leading, .trailing], 12)
            }
            .frame(
                width: UIScreen.main.bounds.width > 744
                ? UIScreen.main.bounds.width / 1.7
                : UIScreen.main.bounds.width
            )
        }
    }
}

private extension PackageGameTaskView {
    func _TimerView() -> some View {
        let value1 = viewModel2.timeRemaining / 60
        let value2 = viewModel2.timeRemaining % 60

        return AnyView(
            StringButton(String(format: "%02d:%02d", value1, value2))
                .onReceive(timer) { _ in
                    if viewModel2.timeRemaining > 0 {
                        viewModel2.timeRemaining -= 1
                    }
                    else {
                        self.outputHandler(.taskBecameStatefull(.incorrect(self.task, "Time ended")))
                    }
                }
            )
    }

    func StringButton(_ string: String) -> some View {
        ZStack {
            Rectangle()
                .cornerRadius(7)
                .foregroundColor(.gray.opacity(0.2))
            Text(string)
            .padding([.leading, .trailing], 10)
            .padding([.bottom, .top], 5)
        }
    }


    func packageGamePanelGetEvent(_ event: PackageGamePanelView.EventOutput) {
        switch event {
        case .tapWord(let selectedWord):
            var textArr = viewModel2.textFieldText
                .split(separator: " ")
                .map { return String($0) }
            if textArr.isEmpty {
                viewModel2.textFieldText += "\(selectedWord) "
                return
            }
            if let last = textArr.last, selectedWord.lowercased().contains(last.lowercased()) {
                textArr.removeLast()
                textArr.append(selectedWord)
                viewModel2.textFieldText = textArr.joined(separator: " ")
                viewModel2.textFieldText += " "
            }
            else {
                viewModel2.textFieldText += "\(selectedWord) "
            }

        case .next:
            let string1 = task
                .data
                .answer
                .lowercased()
                .replacingOccurrences(of: " ", with: "")

            let string2 = viewModel2.textFieldText
                .lowercased()
                .replacingOccurrences(of: " ", with: "")
            outputHandler(
                .taskBecameStatefull(
                    string1 == string2
                    ? .correct(task)
                    : .incorrect(task, viewModel2.textFieldText)
                )
            )
        }
    }

    func packageGamePanelGetEvent(_ event: FlexibleGamePanelView.EventOutput) {
        switch event {
        case .tapWord(let selectedWord):
            var textArr = viewModel2.textFieldText
                .split(separator: " ")
                .map { return String($0) }
            if textArr.isEmpty {
                viewModel2.textFieldText += "\(selectedWord) "
                return
            }
            if let last = textArr.last, selectedWord.lowercased().contains(last.lowercased()) {
                textArr.removeLast()
                textArr.append(selectedWord)
                viewModel2.textFieldText = textArr.joined(separator: " ")
                viewModel2.textFieldText += " "
            }
            else {
                viewModel2.textFieldText += "\(selectedWord) "
            }

        case .menuCase(let menuCase):
            switch menuCase {
            case .next:
                let string1 = task
                    .data
                    .answer
                    .lowercased()
                    .replacingOccurrences(of: " ", with: "")

                let string2 = viewModel2.textFieldText
                    .lowercased()
                    .replacingOccurrences(of: " ", with: "")
                outputHandler(
                    .taskBecameStatefull(
                        string1 == string2
                        ? .correct(task)
                        : .incorrect(task, viewModel2.textFieldText)
                    )
                )

            case .keyboardAction:
                isKeyboardFocused.toggle()
            }
        }
    }
}

//
//struct PackageGameTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        //PackageGameTaskView.init(task: .mock, viewModel2: .init(), extraAnswerTime: 0, outputHandler: { _ in })
//        //PackageGameTaskView.init(task: .mock,  outputHandler: {_ in })
//    }
//}




//
//class PackageGameTaskViewViewModel2: ObservableObject {
//    init(timeRemaining: Int?, extraAnswerTime: Int) {
//        //self.textFieldText = ""
//        self.timeRemaining = timeRemaining ?? extraAnswerTime
//    }
//
//    //@Published var textFieldText: String
//    @Published var timeRemaining: Int
//}
//
//struct PackageGameTaskView: View {
//
//    enum OutputEvent {
//        case taskBecameStatefull(StateTask)
//    }
//
//    let task: Task
//    let outputHandler: (OutputEvent) -> Void
//
//    init(
//        task: Task,
//        vm: PackageGameTaskViewViewModel2,
//        outputHandler: @escaping (OutputEvent) -> Void
//    ) {
//        self.task = task
//        self.outputHandler = outputHandler
//
//        self.vm = VM(timeRemaining: task.answerTime ?? 512)
//    }
//
//    private let arr: [Int] = [100, 200, 300, 400, 500]
//
//    @State private var counter: Int = 0
//
//    var body: some View {
//        VStack {
//            Text(task.data.question)
//            //_ContentView(timeRemaining: arr[counter])
//
//            VStack {
//                TextField("enter", text: $vm.textFieldInput)
//                Text(String(vm.timeRemaining))
//                    .onReceive(timer) { _ in
//                        if vm.timeRemaining > 0 {
//                            vm.timeRemaining -= 1
//                        }
//                        else {
//
//                        }
//                    }
//            }
//            .padding()
//
//            Button("click me") {
//                //counter += 1
//                self.outputHandler(.taskBecameStatefull(.correct(task)))
//            }
//        }
//    }
//
//
//
//    @ObservedObject var vm: VM //= VM(timeRemaining: 200)
//
//
//    private let timer = Timer
//        .publish(every: 1, on: .main, in: .common)
//        .autoconnect()
//}
//
//class VM: ObservableObject {
//    init(timeRemaining: Int) {
//        self.timeRemaining = timeRemaining
//    }
//
//    @Published var timeRemaining: Int
//    @Published var textFieldInput: String = ""
//}
//
//struct _ContentView: View {
//    @ObservedObject var vm: VM = VM(timeRemaining: 200)
//
//    init(timeRemaining: Int) {
//        self.vm = .init(timeRemaining: timeRemaining)
//    }
//
//    var body: some View {
//        VStack {
//            TextField("enter", text: $vm.textFieldInput)
//            Text(String(vm.timeRemaining))
//                .onReceive(timer) { _ in
//                    if vm.timeRemaining > 0 {
//                        vm.timeRemaining -= 1
//                    }
//                    else {
//
//                    }
//                }
//        }
//        .padding()
//    }
//
//    private let timer = Timer
//        .publish(every: 1, on: .main, in: .common)
//        .autoconnect()
//}
