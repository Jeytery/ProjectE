//
//  PackageDeviceStorageService.swift
//  ProjectE
//
//  Created by Jeytery on 03.07.2023.
//

import Foundation

class PackageDeviceStorageService {
    enum AppPackagesServiceError: Error {
        case nilInStorageByKey
        case failedToParsePackages
        
        case failedToParseInJson
    }
    
    private let storage = UserDefaults.standard
    private let key = "PackageDeviceStorageService.packages.key"
}

extension PackageDeviceStorageService {
    func getAppPackages() -> Result<[AppPackage], AppPackagesServiceError> {
        guard let data = storage.data(forKey: key) else {
            return .failure(.nilInStorageByKey)
        }
        guard let packages = try? JSONDecoder().decode([AppPackage].self, from: data) else {
            return .failure(.failedToParsePackages)
        }
        return .success(packages)
    }
    
    func saveAppPackages(_ appPackages: [AppPackage]) -> AppPackagesServiceError? {
        guard let jsonData = try? JSONEncoder().encode(appPackages) else {
            return .failedToParseInJson
        }
        storage.removePersistentDomain(forName: key)
        storage.set(jsonData, forKey: key)
        return nil
    }
}
