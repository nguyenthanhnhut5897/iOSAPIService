//
//  Constants.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/12.
//

import Foundation

internal struct Constants {
    static let CachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy
    static let TimeoutInterval: TimeInterval = 60.0 //60s
    static let RetryCount: Int = 3
    static let RetryTimeInterval: TimeInterval = 0
    static let AllowDelayProgressive: Bool = true
}
