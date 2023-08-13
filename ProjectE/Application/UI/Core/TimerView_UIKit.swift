//
//  TimerView_UIKit.swift
//  ProjectE
//
//  Created by Jeytery on 09.08.2023.
//

import Foundation
import UIKit
import SwiftUI

class _TimerView_UIKit: UIView {
    private let label = UILabel()
    private let didExpired: () -> Void
    
    private var timeRemaining: Int
    private var timer: Timer!
    
    init(
        seconds: Int,
        didExpired: @escaping () -> Void
    ) {
        self.timeRemaining = seconds
        self.didExpired = didExpired
        super.init(frame: .zero)
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        self.backgroundColor = UIColor(.gray.opacity(0.2))
        self.label.textColor = .systemBlue
        self.layer.cornerRadius = 30 / 2
    }
    
    deinit {
        timer = nil 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTime(seconds: Int) {
        let value1 = seconds / 60
        let value2 = seconds % 60
        self.label.text = String(format: "%02d:%02d", value1, value2)
    }
    
    private func configureTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] timer in
            guard let self = self else {
                return
            }
            self.setTime(seconds: self.timeRemaining)
            // [!] state
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
            else {
                self.didExpired()
            }
        }
    }
    
    func update(seconds: Int) {
        timer?.invalidate()
        self.timeRemaining = seconds
        setTime(seconds: self.timeRemaining)
        self.timeRemaining -= 1
        configureTimer()
    }
}

struct TimerView_UIKit: UIViewRepresentable {
    init(
        vm: TimerViewViewModel,
        didExpired: @escaping () -> Void
    ) {
        self.vm = vm
        self.didExpired = didExpired
    }
    
    func makeUIView(context: Context) -> _TimerView_UIKit {
        return _TimerView_UIKit(seconds: vm.timeRemaining, didExpired: didExpired)
    }
    
    func updateUIView(_ uiView: _TimerView_UIKit, context: Context) {
        uiView.update(seconds: vm.timeRemaining)
    }
        
    private let vm: TimerViewViewModel
    private let didExpired: () -> Void
}
