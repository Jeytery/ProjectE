//
//  FlexibleGamePanelView.swift
//  ProjectE
//
//  Created by Jeytery on 09.08.2023.
//

import SwiftUI

struct FlexibleGamePanelView: View {
    enum EventOutput {
        enum MenuCase {
            case next
            case keyboardAction
        }
        
        case tapWord(String)
        case menuCase(MenuCase)
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
        ZStack {
            Color.gray.opacity(0.1)
                .cornerRadius(12)
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
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
                .frame(height: 30)
                .safeAreaInset(edge: .leading, spacing: 12) {
                    Spacer()
                        .frame(height: 44)
                }
                .safeAreaInset(edge: .trailing, spacing: 12) {
                    Spacer()
                        .frame(height: 44)
                }
                .animation(.spring(blendDuration: 0.1))

                HStack {
                    ImageButton(
                        systemName: isDown ? "chevron.up.circle.fill" : "chevron.down.circle.fill",
                        color: .gray
                    ) {
                        eventOutputHandler(.menuCase(.keyboardAction))
                        isDown.toggle()
                    }
                    ImageButton(
                        systemName: "delete.backward.fill",
                        color: .gray
                    ) {
                        var arr = input.split(separator: " ")
                        if arr.isEmpty { return }
                        arr.removeLast()
                        input = arr.joined(separator: " ") + " "
                    }
                    ImageButton(
                        systemName: "arrowtriangle.forward.fill",
                        color: .gray
                    ) {
                        eventOutputHandler(.menuCase(.next))
                    }
                    Spacer()
                }
                .padding([.leading], 12)
                .padding([.top], 0)
            }
        }
    }
    
    private let service: PackageGamePanelService
    
    @State private var isDown: Bool = false
    
    @Binding
    private var input: String
}

private extension FlexibleGamePanelView {
    func ImageButton(
        systemName: String,
        color: Color = .blue,
        action: @escaping () -> Void
    ) -> some View {
        ZStack {
            Color.gray.opacity(0.2)
                .frame(width: 40, height: 30)
                .cornerRadius(10)
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
                eventOutputHandler(.tapWord(string))
            }
            .padding([.leading, .trailing], 10)
            .padding([.bottom, .top], 5)
        }
    }
}

struct FlexibleGamePanelView_Previews: PreviewProvider {
    @State static var test: String = ""
    
    static var previews: some View {
        FlexibleGamePanelView(strings: ["test", "testffffwfwf", "tesfwfwfwfwft",], input: $test, eventOutputHandler: {
            _ in
        })
        .frame(height: 300)
    }
}
