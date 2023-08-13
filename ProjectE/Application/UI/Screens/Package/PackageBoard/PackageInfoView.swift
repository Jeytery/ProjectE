//
//  PackageInfoView.swift
//  ProjectE
//
//  Created by Jeytery on 02.07.2023.
//

import SwiftUI
import SettingsIconGenerator

// add into store
struct PackageInfoView: View {
    enum ViewEvent {
        case tapedAddPackage(AppPackage)
    }
    
    var eventOutputHandler: ((ViewEvent) -> Void)?
    
    init(appPackage: AppPackage) {
        self.appPackage = appPackage
    }
    
    var body: some View {
        Form {
            Section(header: Text("Package name")) {
                HStack {
                    Image(uiImage: UIImage.generateSettingsIcon("scribble.variable", backgroundColor: .systemBlue)!)
                    Text(appPackage.package.name)
                }
            }
            Section {
                HStack {
                    Image(uiImage: UIImage.generateSettingsIcon("star.bubble.fill", backgroundColor: .systemBlue)!)
                    Text("Tasks")
                    Spacer()
                    Text(String(appPackage.package.tasks.count))
                }
                if let gameTaskCount = appPackage.package.gameTaskCount {
                    HStack {
                        Image(
                            uiImage: UIImage.generateSettingsIcon("clock.fill", backgroundColor: .systemBlue)!
                        )
                        Text("Tasks for one game")
                        Spacer()
                        Text(String(gameTaskCount))
                    }
                }
            }
            Section(header: Text("Score")) {
                ForEach(
                    appPackage.package.scoreTables,
                    id: \.self
                ) { value in
                    HStack {
                        Text(value.name)
                        Spacer()
                        Text(String(value.score) + " points")
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Add") {
                    eventOutputHandler?(.tapedAddPackage(self.appPackage))
                }
                .font(.system(size: 19, weight: .semibold, design: .default))
            }
        }
    }
    
    private let appPackage: AppPackage
}

struct PackageInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PackageInfoView(
            appPackage: .init(
                package: .empty,
                score: 10,
                isPinned: false,
                dateLastOpened: .notOpenedYet
            )
        )
    }
}
