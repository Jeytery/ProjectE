//
//  PackageGamePanelView.swift
//  ProjectE
//
//  Created by Dmytro Ostapchenko on 09.07.2023.
//

import SwiftUI

struct PackageGamePanelView2: View {
    
    enum EventOutput {
        case tapWord(String)
    }
    
    var eventOutputHandler: (EventOutput) -> Void
    
    init(
        strings: [String],
        input: Binding<String>,
        eventOutputHandler: @escaping (EventOutput) -> Void
    ) {
        self.eventOutputHandler = eventOutputHandler
        self._input = input
        self.service = PackageGamePanelService(strings: strings)
    }
    
    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(
                        service.currentStrings(for: input),
                        id: \.self
                    ) {
                        StringButton($0)
                    }
                }
            }
        }
    }
    
    @Binding
    private var input: String
    
    private let service: PackageGamePanelService
}

private extension PackageGamePanelView2 {
    func StringButton(_ string: String) -> some View {
        ZStack {
            Rectangle()
                .cornerRadius(7)
                .foregroundColor(.gray.opacity(0.2))
            Button(string) {
                self.eventOutputHandler(.tapWord(string))
            }
            .padding([.leading, .trailing], 10)
            .padding([.bottom, .top], 5)
        }
    }
}

struct PackageGamePanelView2_Previews: PreviewProvider {
    @State static var string = ""
    
    static var previews: some View {
        PackageGamePanelView2(strings: ["do", "does"], input: $string) { _ in }
            .frame(height: 100)
    }
}
