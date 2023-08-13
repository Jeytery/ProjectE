//
//  PackageMenuCellView.swift
//  ProjectE
//
//  Created by Jeytery on 06.08.2023.
//

import SwiftUI

struct PackageMenuCellView: View {
    init(
        appPackage: AppPackage,
        withDisclosureIndicator: Bool,
        action: @escaping () -> Void
    ) {
        self.appPackage = appPackage
        self.action = action
    }
    
    init(
        package: Package,
        withDisclosureIndicator: Bool,
        action: @escaping () -> Void
    ) {
        self.appPackage = .withPackage(package)
        self.action = action
    }
    
    
    private let appPackage: AppPackage
    private let action: () -> Void
    
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(appPackage.package.name)
                        .font(.system(size: 17, weight: .regular, design: .default))
                    Spacer()
                        .frame(height: 2)
                    Text("Tasks: \(appPackage.package.tasks.count)")
                        .font(.system(size: 13, weight: .regular, design: .default))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding([.bottom, .top], 3.5)
            
            Button("") {
                action()
            }
        }
    }
}

struct PackageMenuCellView_Previews: PreviewProvider {
    static var previews: some View {
        PackageMenuCellView(appPackage: .mock, withDisclosureIndicator: true, action: {})
    }
}

