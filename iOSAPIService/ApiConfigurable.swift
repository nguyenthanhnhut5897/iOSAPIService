//
//  ApiConfigurable.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/08.
//

import Foundation

public protocol ApiConfigurable {
    var baseURL: URL { get }
    var sessionToken: String? { get }
    var additionalHeaders: [String: String] { get }
    var cachePolicy: NSURLRequest.CachePolicy { get }
    var timeoutInterval: TimeInterval { get }
    
    var retryCount: Int { get }
    var retryTimeInterval: TimeInterval { get }
    var allowDelayProgressive: Bool { get }
}

public struct ApiDataConfigurable: ApiConfigurable {
    public var baseURL: URL
    public var sessionToken: String?
    public var additionalHeaders: [String: String]
    public var cachePolicy: NSURLRequest.CachePolicy
    public var timeoutInterval: TimeInterval
    
    public var retryCount: Int
    public var retryTimeInterval: TimeInterval
    public var allowDelayProgressive: Bool

    init(baseURL: URL,
         sessionToken: String? = nil,
         cachePolicy: NSURLRequest.CachePolicy = Constants.CachePolicy,
         timeoutInterval: TimeInterval = Constants.TimeoutInterval,
         additionalHeaders: [String: String] = [:],
         retryCount: Int = Constants.RetryCount,
         retryTimeInterval: TimeInterval = Constants.RetryTimeInterval,
         allowDelayProgressive: Bool = Constants.AllowDelayProgressive) {
        
        self.baseURL = baseURL
        self.sessionToken = sessionToken
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
        self.additionalHeaders = additionalHeaders
        
        self.retryCount = retryCount
        self.retryTimeInterval = retryTimeInterval
        self.allowDelayProgressive = allowDelayProgressive
    }
}
