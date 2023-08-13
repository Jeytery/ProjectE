//
//  TimerView.swift
//  ProjectE
//
//  Created by Jeytery on 05.08.2023.
//

import SwiftUI
import Foundation

final class TimerViewViewModel: ObservableObject {
    @Published var timeRemaining: Int = 0
}

struct TimerView: View, Equatable {
    var uuid = UUID()
    
    static func == (lhs: TimerView, rhs: TimerView) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    enum TimeValue {
        case minutes(Int)
        case seconds(Int)
    }
    
    init(
        viewModel: TimerViewViewModel,
        didExpired: @escaping () -> Void
    ) {
        self.didExpired = didExpired
        self.viewModel = viewModel
    }
    
    init(timeValue: TimeValue, didExpired: @escaping () -> Void) {
        self.didExpired = didExpired
        self.viewModel = TimerViewViewModel()
        
        switch timeValue {
        case .seconds(let value):
            viewModel.timeRemaining = value
        case .minutes(let value):
            viewModel.timeRemaining = value * 60
        }
    }
    
    var body: some View {
        let value1 = viewModel.timeRemaining / 60
        let value2 = viewModel.timeRemaining % 60
        StringButton(String(format: "%02d:%02d", value1, value2))
            .onReceive(timer) { _ in
                if viewModel.timeRemaining > 0 {
                    viewModel.timeRemaining -= 1
                }
                else {
                    didExpired()
                }
            }
    }

    private let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()

    private let didExpired: () -> Void
  
    @ObservedObject
    private var viewModel: TimerViewViewModel
}

private extension TimerView {
    func StringButton(_ string: String) -> some View {
        ZStack {
            Rectangle()
                .cornerRadius(7)
                .foregroundColor(.gray.opacity(0.2))
            Button(string) {
            }
            .padding([.leading, .trailing], 10)
            .padding([.bottom, .top], 5)
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timeValue: .seconds(3), didExpired: {})
    }
}
