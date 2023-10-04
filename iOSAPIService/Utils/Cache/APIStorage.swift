//
//  APIStorage.swift
//  iOSAPIService
//
//  Created by Thanh Nhut on 04/10/2023.
//

import Foundation

public struct APIStorage<T: APIBaseCache> {
    private (set) var value: T
    private (set) var expiration: APIStorageExpiration
    private (set) var key: String
    private (set) var estimatedExpiration: Date
    
    public init(_ value: T, key: String, expiration: APIStorageExpiration) {
        self.value = value
        self.key = key
        self.expiration = expiration
        self.estimatedExpiration = expiration.estimatedExpirationSinceNow
    }
    
    public mutating func extendExpiration() {
        self.estimatedExpiration = expiration.estimatedExpirationSinceNow
    }
    
    public var expired: Bool {
        return estimatedExpiration.isPast
    }
}
