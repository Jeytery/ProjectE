//
//  PackageGamePanelView.swift
//  ProjectE
//
//  Created by Dmytro Ostapchenko on 09.07.2023.
//

import SwiftUI

struct PackageGamePanelView: View {
    
    enum EventOutput {
        case tapWord(String)
        case next
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
            ImageButton(systemName: "delete.backward.fill", color: .gray) {
                var arr = input.split(separator: " ")
                if arr.isEmpty { return }
                arr.removeLast()
                input = arr.joined(separator: " ") + " "
            }
            ImageButton(systemName: "arrow.forward.circle.fill") {
                eventOutputHandler(.next)
            }
        }
    }
    
    @Binding
    private var input: String
    
    private let service: PackageGamePanelService
}

private extension PackageGamePanelView {
    func ImageButton(
        systemName: String,
        color: Color = .blue,
        action: @escaping () -> Void
    ) -> some View {
        ZStack {
            Button {
                action()
            } label: {
                Image(systemName: systemName)
                    .foregroundColor(color)
            }
        }
    }
    
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

struct PackageGamePanelView_Previews: PreviewProvider {
    @State static var string = ""
    
    static var previews: some View {
        PackageGamePanelView(strings: ["do", "does"], input: $string) { _ in }
            .frame(height: 100)
    }
}
