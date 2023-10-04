//
//  APICacheProtocol.swift
//  iOSAPIService
//
//  Created by Thanh Nhut on 04/10/2023.
//

import Foundation

public protocol APIBaseCache: Decodable {
    var baseId: String? { get }
}

public protocol APICacheProtocol {
    associatedtype Cache: APIBaseCache
    
    var container: [String: APIStorage<Cache>] { get set }
    
    func value(forKey key: String) -> Cache?
    func setValue(_ value: Cache, forKey key: String)
    func setValue(_ value: Cache, forKey key: String, expiration: APIStorageExpiration)
    func removeAll()
    func setCaches(_ caches: [Cache])
}
