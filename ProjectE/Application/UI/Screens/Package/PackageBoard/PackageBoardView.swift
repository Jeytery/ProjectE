//
//  PackageBoardView.swift
//  ProjectE
//
//  Created by Jeytery on 03.07.2023.
//

import SwiftUI

class PackageBoardViewViewModel: ObservableObject {
    @Published var appPackage: AppPackage
    
    init(appPackage: AppPackage) {
        self.appPackage = appPackage
    }
}

// before the game starts
struct PackageBoardView: View {
    enum OutputEvent {
        case pinnedPackage(AppPackage)
        case startPackage(AppPackage)
        case tapGameResult(GameResult)
    }
    
    var eventOutputHandler: ((OutputEvent) -> Void)?
        
    init(appPackage: AppPackage) {
        self.viewModel = .init(appPackage: appPackage)
    }

    var body: some View {
        List {
            Section(header: Text("Package name")) {
                HStack {
                    Image(uiImage: UIImage.generateSettingsIcon("scribble.variable", backgroundColor: .systemBlue)!)
                    Text(viewModel.appPackage.package.name)
                }
            }
            Section {
                HStack {
                    Image(uiImage: UIImage.generateSettingsIcon("star.bubble.fill", backgroundColor: .systemBlue)!)
                    Text("Tasks")
                    Spacer()
                    Text(String(viewModel.appPackage.package.tasks.count))
                }
                
                if let gameTaskCount = viewModel.appPackage.package.gameTaskCount {
                    HStack {
                        Image(uiImage: UIImage.generateSettingsIcon("clock.fill", backgroundColor: .systemBlue)!)
                        Text("Tasks for one game")
                        Spacer()
                        Text(String(gameTaskCount))
                    }
                }
            }
            Section(header: Text("Score")) {
                ForEach(
                    viewModel.appPackage.package.scoreTables,
                    id: \.self
                ) { value in
                    if
                        let bestResult = viewModel.appPackage.bestResult,
                        bestResult.score >= value.score
                    {
                        HStack {
                            Text(value.name)
                                .foregroundColor(.green)
                            Spacer()
                            Text(String(value.score) + " points")
                                .foregroundColor(.green)
                        }
                    }
                    else {
                        HStack {
                            Text(value.name)
                            Spacer()
                            Text(String(value.score) + " points")
                        }
                    }
                }
            }
            if let bestResult = viewModel.appPackage.bestResult {
                Section() {
                    ZStack {
                        HStack {
                            Image(uiImage: UIImage.generateSettingsIcon("crown.fill", backgroundColor: .systemOrange)!)
                            Text("Best Result")
                            Spacer()
                            Text(String(bestResult.score))
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        Button("") {
                            self.eventOutputHandler?(.tapGameResult(bestResult))
                        }
                    }
                }
            }
            if !viewModel.appPackage.lastGameResults.isEmpty {
                Section(header: Text("History")) {
                    ForEach(
                        viewModel.appPackage.lastGameResults,
                        id: \.self
                    ) { value in
                        ZStack {
                            HStack {
                                Text("Score")
                                Spacer()
                                Text(String(value.score))
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            Button("") {
                                self.eventOutputHandler?(.tapGameResult(value))
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.appPackage.isPinned.toggle()
                    self.eventOutputHandler?(.pinnedPackage(self.viewModel.appPackage))
                } label: {
                    Image(systemName: viewModel.appPackage.isPinned ? "star.fill" : "star")
                }
                FooterButton()
            }
        }
    }
    
    @ObservedObject private var viewModel: PackageBoardViewViewModel
}

private extension PackageBoardView {
    func FooterButton() -> some View {
        Button("Start") {
            self.eventOutputHandler?(.startPackage(self.viewModel.appPackage))
        }
        .buttonStyle(.bordered)
        .tint(.blue)
    }
}

struct PackageBoardView_Previews: PreviewProvider {
    static var previews: some View {
        PackageBoardView(appPackage: .withPackage(.empty))
    }
}
