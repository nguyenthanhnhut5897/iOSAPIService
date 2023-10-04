//
//  APICacheCenter.swift
//  iOSAPIService
//
//  Created by Thanh Nhut on 04/10/2023.
//

import Foundation

public class APICacheCenter<T: APIBaseCache>: APICacheProtocol {
    public typealias Cache = T
    public var container: [String : APIStorage<T>] = [:]
    
    let expiration: APIStorageExpiration
    let cleanInterval: TimeInterval
    
    // The time interval between the storage do clean work for swiping expired items.
    private var cleanTimer: Timer? = nil
    private let lock = NSLock()
    
//    private(set) var estimatedExpiration: Date?
    
    public init(expiration: APIStorageExpiration = .never, cleanInterval: TimeInterval = 120) {
        self.expiration = expiration
        self.cleanInterval = cleanInterval
        
//        self.estimatedExpiration = expiration.estimatedExpirationSinceNow
        
        cleanTimer = Timer.scheduledTimer(withTimeInterval: cleanInterval, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.removeExpired()
        })
    }
    
//    public func extendExpiration() {
//        self.estimatedExpiration = expiration.estimatedExpirationSinceNow
//    }
//
//    public var expired: Bool {
//        return estimatedExpiration?.isPast ?? true
//    }
    
    private func removeExpired() {
        lock.lock()
        defer { lock.unlock() }
        
        let cache = container
    
        for (key, value) in cache {
            if value.estimatedExpiration.isPast {
                container.removeValue(forKey: key)
            }
        }
    }
    
    // Use this when you actually access the memory cached item.
    // This will extend the expired data for the accessed item.
    private func value(forKey key: String, extendingExpiration: Bool) -> Cache? {
        guard var item = container[key] else {
            return nil
        }
        
        if item.expired {
            return nil
        }
        
        if extendingExpiration { item.extendExpiration() }
        
        return item.value
    }
    
    public func setValue(_ value: Cache, forKey key: String, expiration: APIStorageExpiration) {
        lock.lock()
        defer { lock.unlock() }
        
        // The expiration indicates that already expired, no need to store.
        guard !expiration.isExpired else { return }
        
        let stograge = APIStorage<Cache>(value, key: key, expiration: expiration)
        container[key] = stograge
    }
    
    public func setValue(_ value: Cache, forKey key: String) {
        setValue(value, forKey: key, expiration: self.expiration)
    }
    
    public func value(forKey key: String) -> Cache? {
        return value(forKey: key, extendingExpiration: true)
    }
    
    public func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        
        container.removeAll()
    }
    
    public func setCaches(_ caches: [Cache]) {
        caches.forEach { (cache) in
            if let baseId = cache.baseId {
                setValue(cache, forKey: baseId)
            }
        }
    }
}
