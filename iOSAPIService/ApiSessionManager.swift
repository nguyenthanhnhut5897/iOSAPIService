//
//  ApiSessionManager.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/13.
//

import Foundation

public protocol ApiSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    @discardableResult
    func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> SessionCancellable
}

public struct DefaultApiSessionManager: ApiSessionManager {
    private var session: URLSession
    private var configType: ApiSessionConfigurationType
    
    private init() {
        self.configType = .default
        self.session = URLSession(configuration: .default)
    }
    
    public init(with configType: ApiSessionConfigurationType) {
        self.configType = configType
        
        let config = DefaultApiSessionManager.urlSessionConfig(with: configType)
        self.session = URLSession(configuration: config)
    }
    
    static func urlSessionConfig(with configType: ApiSessionConfigurationType) -> URLSessionConfiguration {
        var config = URLSessionConfiguration.default
        
        switch configType {
        case .ephemeral:
            config = URLSessionConfiguration.ephemeral
        case .custom(_, let customType):
            if customType == .ephemeral {
                config = URLSessionConfiguration.ephemeral
            }
        default:
            break
        }
        
        return config
    }
    
    public func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> SessionCancellable {
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}
