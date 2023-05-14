//
//  DataErrorResolver.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/14.
//

import Foundation

public protocol DataErrorResolver {
    func resolve(error: NetworkError) -> Error
}

// MARK: - Error Resolver
public struct DefaultDataErrorResolver: DataErrorResolver {
    public init() {}
    
    public func resolve(error: NetworkError) -> Error {
        return error
    }
}
