//
//  NetworkPackageService.swift
//  ProjectE
//
//  Created by Jeytery on 03.07.2023.
//

import Foundation
import Alamofire

class NetworkPackageService {
    
    enum GetPackagesError: Error {
        case noInternetConnection
        case dataIsEmpty
        
        case dictionaryParseFailure
        
        case contentOfGitRepositoryIsNil
        
        case base64DataParseFailure
        case stringFromBase64ParseFailure
        
        case jsonDecoderParseFailure
    }
    
    private let link = "https://api.github.com/repos/Jeytery/ProjectE-packages/contents/README.md"
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getPackages(handler: @escaping (Result<[Package], GetPackagesError>) -> Void) {
        AF.request(link, method: .get)
            .responseData { value in
                guard let data = value.data else {
                    return handler(.failure(.dataIsEmpty))
                }
                
                let stroke = String(decoding: data, as: UTF8.self)
                
                guard let dict = self.convertToDictionary(text: stroke) else {
                    return handler(.failure(.dictionaryParseFailure))
                }
                
                guard let content = dict["content"] as? String else {
                    return handler(.failure(.contentOfGitRepositoryIsNil))
                }
                
                guard let base64EncodedData = Data(
                    base64Encoded: content,
                    options: .ignoreUnknownCharacters
                ) else {
                    return handler(.failure(.base64DataParseFailure))
                }
                
                guard
                    let finalString = String(
                    data: base64EncodedData,
                    encoding: .utf8
                ) else {
                    return handler(.failure(.stringFromBase64ParseFailure))
                }
                
                let __data = finalString.data(using: .utf8)!
                
                struct NetValue: Codable {
                    let packages: [Package]
                }
                
                do {
                    let value = try JSONDecoder().decode(NetValue.self, from: __data)
                    handler(.success(value.packages))
                }
                catch {
                    print(error)
                    handler(.failure(.jsonDecoderParseFailure))
                }
            }
    }
}

