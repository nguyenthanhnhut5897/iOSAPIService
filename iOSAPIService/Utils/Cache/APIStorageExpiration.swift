//
//  APIStorageExpiration.swift
//  iOSAPIService
//
//  Created by Thanh Nhut on 04/10/2023.
//

import Foundation

/// Represents the expiration strategy used in storage.
///
/// - never: The item never expires.
/// - seconds: The item expires after a time duration of given seconds from now.
/// - days: The item expires after a time duration of given days from now.
/// - date: The item expires after a given date.
public enum APIStorageExpiration {
    /// The item never expires.
    case never
    /// The item expires after a time duration of given seconds from now.
    case seconds(TimeInterval)
    /// The item expires after a time duration of given days from now.
    case days(Int)
    /// The item expires after a given date.
    case date(Date)
    /// Indicates the item is already expired. Use this to skip cache.
    case expired
    
    public func estimatedExpirationSince(_ date: Date) -> Date {
        switch self {
        case .never: return .distantFuture
        case .seconds(let seconds): return date.addingTimeInterval(seconds)
        case .days(let days): return date.addingTimeInterval(TimeInterval(60 * 60 * 24 * days))
        case .date(let ref): return ref
        case .expired: return .distantPast
        }
    }
    
    public var estimatedExpirationSinceNow: Date {
        return estimatedExpirationSince(Date())
    }
    
    public var isExpired: Bool {
        return timeInterval <= 0
    }
    
    public var timeInterval: TimeInterval {
        switch self {
        case .never: return .infinity
        case .seconds(let seconds): return seconds
        case .days(let days): return TimeInterval(60 * 60 * 24 * days)
        case .date(let ref): return ref.timeIntervalSinceNow
        case .expired: return -(.infinity)
        }
    }
}
