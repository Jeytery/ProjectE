//
//  PackageGameCounterView.swift
//  ProjectE
//
//  Created by Jeytery on 06.07.2023.
//

import SwiftUI
import Combine

struct PackageGameCounterView: View {
    var finishedCounter: (() -> Void)?
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(uiColor: .systemBackground))
            Text("\(counterText)")
                .font(.system(size: 120, weight: .bold, design: .rounded))
                .foregroundColor(.black.opacity(0.8))
                .onReceive(timer) { _ in
                    if counterText > 1 {
                        counterText -= 1
                    }
                    else {
                        finishedCounter?()
                    }
                }
        }
    }
    
    init(maxValue: Int, completion: @escaping () -> Void) {
        self.counterText = maxValue
        self.finishedCounter = completion
    }
    
    @State private var counterText: Int
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
}

struct PackageGameCounterView_Previews: PreviewProvider {
    static var previews: some View {
        PackageGameCounterView(maxValue: 3, completion: {})
    }
}
