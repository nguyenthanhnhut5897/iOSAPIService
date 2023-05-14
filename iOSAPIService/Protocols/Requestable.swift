//
//  Requestable.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/08.
//

import Foundation

public protocol Requestable {
    
    // The response of Requestable
    associatedtype Response
    
    // MARK: - Genaral
    
    // The base of URL.
    var baseURL: URL? { get }
    
    // The path of URL.
    var path: String { get }
    
    // The header of HTTP
    var headerField: [String: String] { get }
    
    // The additional header of HTTP
    var additionalHeaders: [String: String] { get }
    
    // Http method type
    var httpMethod: HTTPMethod { get }
    
    // The http body parameter, The default value is `nil`.
    var httpBody: Data? { get }
    
    // Additional query paramters for URL, The default value is `[:]`.
    var queryParameters: [String: Any] { get }
    
    // If an requestable needs OAuth authorization, need to set `true`. The default value is `false`.
    var isAuthorizedRequest: Bool { get }
    
    // A piece of information that identifies a specific user's session with the server.
    var sessionToken: String? { get }
    
    // Default is 60 seconds
    var timeoutInterval: TimeInterval { get }
    
    
    // MARK: - Decoding
    
    // The strategy to use for decoding `Date` values. Defaults to `.deferredToDate`.
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
    
    /// The strategy to use for decoding `Data` values. Use in decoding binary data. Defaults to `.base64`.
    var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy { get }
    
    /// The strategy to use for non-JSON-conforming floating-point values. Defaults to `.throw`.
    var nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy { get }

    /// The strategy to use for automatically changing the value of keys before decoding. Defaults to `.useDefaultKeys`.
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }

    /// Contextual user-provided information for use during decoding.
    var userInfo: [CodingUserInfoKey : Any] { get }
    
    
    // MARK: - Auto-retry config
    
    // The number of times to retry. Default value is 3
    var retryCount: Int { get }
    
    // The duration time for the next retry. Default value is 0
    var retryTimeInterval: TimeInterval { get }
    
    // Allow apply progressive time to calculate for next retry or not. Default value is true
    var allowDelayProgressive: Bool { get }
    
    
    // MARK: - Cache
    
    // Cache policy for every request
    var cachePolicy: NSURLRequest.CachePolicy { get }
}
