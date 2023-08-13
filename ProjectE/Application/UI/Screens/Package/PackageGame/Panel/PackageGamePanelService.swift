//
//  PackageGamePanelService.swift
//  ProjectE
//
//  Created by Dmytro Ostapchenko on 09.07.2023.
//

import Foundation

class PackageGamePanelService {
    init(strings: [String]) {
        self.originalStrings = strings
    }
    
    private(set) var originalStrings: [String]
}

private extension PackageGamePanelService {
    func sortStrings(_ array: [String], basedOn mainString: String) -> [String] {
        return array.sorted { (str1, str2) -> Bool in
            // Convert the strings to lowercase
            let lowercasedStr1 = str1.lowercased()
            let lowercasedStr2 = str2.lowercased()

            // Calculate the index of the mainString in each string
            guard let index1 = lowercasedStr1.range(of: mainString.lowercased())?.lowerBound else { return false }
            guard let index2 = lowercasedStr2.range(of: mainString.lowercased())?.lowerBound else { return true }
            
            // Compare the indices
            return index1 < index2
        }
    }
}

extension PackageGamePanelService {
    func currentStrings(for input: String) -> [String] {
        let inputWordArray = Array(input.split(separator: " "))
        if let lastWord = inputWordArray.last {
            return sortStrings(self.originalStrings, basedOn: String(lastWord))
        }
        else {
            return self.originalStrings
        }
    }
}

