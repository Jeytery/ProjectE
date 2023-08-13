//
//  PackageFormatter.swift
//  ProjectE
//
//  Created by Jeytery on 03.07.2023.
//

import Foundation

struct FormattedAppPackages {
    let allLeftPackages: [AppPackage]
    let pinnedPackages: [AppPackage]
    let lastOpenedPackages: [AppPackage]
    
    let allPackages: [AppPackage]
    
    static let empty = FormattedAppPackages(allLeftPackages: [], pinnedPackages: [], lastOpenedPackages: [], allPackages: [])
}

class PackageFormatter {
    init(appPackages: [AppPackage]) {
        self.appPackages = appPackages
    }
    
    var appPackages: [AppPackage]
    private let countOfLastOpened: Int = 3
}

private extension PackageFormatter {
    var allLeftPackages: [AppPackage] {
        return appPackages
    }
    
    var pinnedPackages: [AppPackage] {
        return appPackages.filter {
            return $0.isPinned
        }
    }
    
    func lastOpenedPackages(count: Int) -> [AppPackage] {
        let slice = appPackages
            .filter {
                $0.dateLastOpened != .notOpenedYet
            }
            .sorted {
                $0.dateLastOpened > $1.dateLastOpened
            }
            .prefix(count)
        return Array(slice)
    }
}

extension PackageFormatter {
    func openPackage(_ package: AppPackage) {
        for index in 0 ..< appPackages.count {
            let _package = appPackages[index]
            if _package.id == package.id {
                appPackages[index].dateLastOpened = .opened(data: Date())
            }
        }
    }
    
    func getFormattedPackages() -> FormattedAppPackages {
        return FormattedAppPackages(
            allLeftPackages: self.allLeftPackages,
            pinnedPackages: self.pinnedPackages,
            lastOpenedPackages: self.lastOpenedPackages(count: self.countOfLastOpened),
            allPackages: self.appPackages
        )
    }
    
    func updatePackage(_ appPackage: AppPackage) {
        for index in 0 ..< appPackages.count {
            let _appPackage = appPackages[index]
            if _appPackage.id == appPackage.id {
                appPackages[index] = appPackage
            }
        }
    }
}
