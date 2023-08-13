//
//  PackageGameTaskViewController.swift
//  ProjectE
//
//  Created by Jeytery on 08.08.2023.
//

import Foundation
import UIKit
import SwiftUI

class PackageGameTaskViewController: UIViewController {
    enum OutputEvent {
        case taskBecameStatefull(StateTask)
    }
    
    var outputHandler: ((OutputEvent) -> Void)?
    
    init(task: Task, extraTimeRemaining: Int = 0) {
        self.extraTimeRemaining = extraTimeRemaining
        super.init(nibName: nil, bundle: nil)
        self.configureSt1()
        fetchData(task: task)
        view.backgroundColor = .systemBackground
        configureTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        answerTextField.becomeFirstResponder()
    }
    
    // state
    private var timeRemaining: Int!
    private var task: Task!
    
    private var timer: Timer!
    
    private let timerLabel = UILabel()
    private let questionLabel = UILabel()
    private let answerTextField = UITextField()
    private let st1 = UIStackView()
    
    private let extraTimeRemaining: Int
    
    private var hostinVC: UIViewController!
}

private extension PackageGameTaskViewController {
    func addCounter() {
        let counter = PackageGameCounterView(maxValue: 3, completion: {
            self.hostinVC.dismiss(animated: true)
        })
        
        hostinVC = UIHostingController(rootView: counter)
        hostinVC.modalPresentationStyle = .overCurrentContext
        hostinVC.modalTransitionStyle = .crossDissolve
        present(hostinVC, animated: false)
    }
    
    func fetchData(task: Task) {
        self.task = task
        self.timeRemaining = task.answerTime ?? extraTimeRemaining
        questionLabel.text = task.data.question
    }
    
    func configureSt1() {
        st1.distribution = .fill
        st1.alignment = .center
        
        st1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(st1)
        
        st1.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        st1.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        st1.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        st1.addArrangedSubview(timerLabel)
        st1.addArrangedSubview(questionLabel)
        st1.addArrangedSubview(answerTextField)
        
        st1.axis = .vertical
        
        answerTextField.placeholder = "Enter answer"
        timerLabel.text = "00:00"
        
        answerTextField.autocorrectionType = .no
        answerTextField.spellCheckingType = .no
    }
    
    func configureTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [unowned self] timer in
            let value1 = self.timeRemaining / 60
            let value2 = self.timeRemaining % 60
            timerLabel.text = String(format: "%02d:%02d", value1 / 60, value2)
            
            // [!] state
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
            else {
                // finish
            }
        }
    }
}

extension PackageGameTaskViewController {
    // [!] state
    func updateTask(task: Task) {
        fetchData(task: task)
        configureTimer()
    }
}

struct PackageGameTaskView_UIKit: UIViewControllerRepresentable {
    private let task: Task
    private let extraAnswerTime: Int
    private let outputHandler: (PackageGameTaskViewController.OutputEvent) -> Void
    
    init(
        task: Task,
        extraAnswerTime: Int = 0,
        outputHandler: @escaping (PackageGameTaskViewController.OutputEvent) -> Void
    ) {
        self.task = task
        self.extraAnswerTime = extraAnswerTime
        self.outputHandler = outputHandler
    }
    
    func makeUIViewController(context: Context) -> PackageGameTaskViewController {
        let packageGameTaskViewController = PackageGameTaskViewController(
            task: task,
            extraTimeRemaining: extraAnswerTime
        )
        packageGameTaskViewController.outputHandler = outputHandler
        return packageGameTaskViewController
    }

    func updateUIViewController(
        _ uiViewController: PackageGameTaskViewController,
        context: Context
    ) {
        
    }
}

