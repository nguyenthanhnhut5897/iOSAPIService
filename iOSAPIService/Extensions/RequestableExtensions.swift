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
    
    var additionalHeaders: [String: String] {
        return [:]
    }
    
    var httpBody: Data? {
        return nil
    }
    
    var queryParameters: [String: Any] {
        return [:]
    }
    
    var isAuthorizedRequest: Bool {
        return true
    }
    
    var sessionToken: String? {
        return nil
    }
    
    var timeoutInterval: TimeInterval {
        return Constants.TimeoutInterval
    }
    
    // MARK: - Decoding
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        let dateFormatter = APIDateFormatter.shared.formatter(for: APIDateFormat.default)
        return .formatted(dateFormatter)
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
    
    var fatalStatusCodes: [Int] {
        return []
    }
    
    
    // MARK: - Cache
    
    var cachePolicy: NSURLRequest.CachePolicy {
        return Constants.CachePolicy
    }
}

extension Requestable {
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.dataDecodingStrategy = dataDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.userInfo = userInfo
        decoder.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
        
        return decoder
    }
    
    var defaultConfig: ApiConfigurable? {
        guard let baseURL = baseURL else { return nil }
        
        let config = ApiDataConfigurable(baseURL: baseURL,
                                         sessionToken: sessionToken,
                                         cachePolicy: cachePolicy,
                                         timeoutInterval: timeoutInterval,
                                         additionalHeaders: additionalHeaders,
                                         fatalStatusCodes: fatalStatusCodes,
                                         retryCount: retryCount,
                                         retryTimeInterval: retryTimeInterval,
                                         allowDelayProgressive: allowDelayProgressive)
        return config
    }
    
    // The delay time before start the next retry
    func delayTimeInterval(retryRemaining: Int, config: ApiConfigurable) -> TimeInterval {
        guard config.allowDelayProgressive else {
            return config.retryTimeInterval
        }
            
        return config.retryTimeInterval * pow(2, Double(config.retryCount) - Double(retryRemaining))
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
        guard let config = defaultConfig else { return nil }
        
        return makeURLRequest(with: config)
    }
    
    func makeURLRequest(with config: ApiConfigurable) -> URLRequest? {
        let url = config.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url, cachePolicy: config.cachePolicy, timeoutInterval: config.timeoutInterval)
        let header: [String: String] = makeHeaderField(config: config)
        
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
