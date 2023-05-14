//
//  RequestableExtensions.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/08.
//

import Foundation

extension Requestable {
    var baseURL: URL? {
        return nil
    }
    
    var headerField: [String: String] {
        return [:]
    }
    
    var HTTPAdditionalHeaders: [String: String] {
        return [:]
    }
    
    var httpBody: Data? {
        return nil
    }
    
    var queryParameters: [String: Any] {
        return [:]
    }
    
    var isAuthorizedRequest: Bool {
        return false
    }
    
    var sessionToken: String? {
        return nil
    }
    
    var timeoutInterval: TimeInterval {
        return Constants.TimeoutInterval
    }
    
    // MARK: - Decoding
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return .deferredToDate
    }
    
    var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy {
        return .base64
    }
    
    var nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy {
        return .throw
    }

    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        .useDefaultKeys
    }
    
    var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }
    
    
    // MARK: - Auto-retry config
    
    var retryCount: Int {
        return Constants.RetryCount
    }
    
    var retryTimeInterval: TimeInterval {
        return Constants.RetryTimeInterval
    }
    
    var allowDelayProgressive: Bool {
        return Constants.AllowDelayProgressive
    }
    
    
    // MARK: - Cache
    
    var cachePolicy: NSURLRequest.CachePolicy {
        return Constants.CachePolicy
    }
}

extension Requestable {
    internal var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.dataDecodingStrategy = dataDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.userInfo = userInfo
        decoder.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
        
        return decoder
    }
    
    // The delay time before start the next retry
    internal func delayTimeInterval(retryRemaining: Int) -> TimeInterval {
        guard allowDelayProgressive else {
            return retryTimeInterval
        }
            
        return retryTimeInterval * pow(2, Double(retryCount) - Double(retryRemaining))
    }
    
    private func makeHeaderField(config: ApiConfigurable) -> [String: String] {
        var header: [String: String] = headerField
        header.merge(config.additionalHeaders) { (_, new) in new }

        if isAuthorizedRequest, let sessionToken = config.sessionToken, !sessionToken.isEmpty {
            header["Authorization"] = "Bearer \(sessionToken)"
        }
        
        return header
    }
    
    func makeURLRequest() -> URLRequest? {
        guard let baseURL = baseURL else { return nil }
        
        let config = ApiDataConfigurable(baseURL: baseURL,
                                         sessionToken: sessionToken,
                                         cachePolicy: cachePolicy,
                                         timeoutInterval: timeoutInterval,
                                         additionalHeaders: HTTPAdditionalHeaders)
        
        return makeURLRequest(with: config)
    }
    
    func makeURLRequest(with config: ApiConfigurable) -> URLRequest? {
        let url = config.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url, cachePolicy: config.cachePolicy, timeoutInterval: config.timeoutInterval)
        var header: [String: String] = makeHeaderField(config: config)
        
        urlRequest.httpMethod = httpMethod.rawValue
        
        header.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        if let body = httpBody {
            urlRequest.httpBody = body
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return urlRequest
        }
        
        let keyParams: [String: Any] = queryParameters
        
        if !keyParams.isEmpty {
            urlComponents.query = keyParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        }
        
        urlRequest.url = urlComponents.url
        
        return urlRequest
    }
}