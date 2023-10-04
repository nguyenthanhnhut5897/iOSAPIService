//
//  ApiSessionService.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/13.
//

import Foundation

public protocol ApiSessionService {
    typealias CompletionResult = Result<Data?, NetworkError>
    typealias CompletionHandler = (CompletionResult) -> Void
    
    @discardableResult
    func send<T>(
        request: T,
        completion: @escaping CompletionHandler
    ) -> SessionCancellable? where T : Requestable
    
    @discardableResult
    func send<T, C>(
        request: T,
        config: C,
        completion: @escaping CompletionHandler
    ) -> SessionCancellable? where T : Requestable, C: ApiConfigurable
}

class DefaultApiSessionService {
    
    private let sessionManager: ApiSessionManager
    private let logger: SessionErrorLogger
    
    init(sessionManager: ApiSessionManager,
        logger: SessionErrorLogger = DefaultSessionErrorLogger()
    ) {
        self.sessionManager = sessionManager
        self.logger = logger
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        
        switch code {
        case .notConnectedToInternet:
            return .notConnected
        case .cancelled:
            return .cancelled
        default:
            return .generic(error)
        }
    }
}

extension DefaultApiSessionService: ApiSessionService {
    @discardableResult
    func send<T>(request: T, completion: @escaping CompletionHandler) -> SessionCancellable? where T : Requestable {
        guard let config = request.defaultConfig else {
            completion(.failure(.baseURLNotExist))
            return nil
        }
        
        return send(request: request, config: config, completion: completion)
    }
    
    @discardableResult
    func send<T, C>(request: T, config: C, completion: @escaping CompletionHandler) -> SessionCancellable? where T : Requestable, C : ApiConfigurable {
        guard let urlRequest = request.makeURLRequest(with: config) else {
            completion(.failure(.urlGeneration))
            return nil
        }
        
        logger.log(request: urlRequest)
        
        return send(request: request,
                    urlRequest: urlRequest,
                    retryRemaining: request.retryCount,
                    config: config,
                    completion: completion)
    }
    
    @discardableResult
    private func send<T, C>(request: T,
                            urlRequest: URLRequest,
                            retryRemaining: Int,
                            config: C,
                            completion: @escaping CompletionHandler
    ) -> SessionCancellable? where T : Requestable, C : ApiConfigurable {
        
        let task = send(urlRequest: urlRequest) { [weak self] result in
            switch result {
            case let .success(data):
                completion(.success(data))
                
            case let .failure(error):
                switch error {
                case let .error(code, _):
                    if self?.isErrorFatal(code) == true || config.fatalStatusCodes.contains(error.code) {
                        self?.logger.log(text: "Request failed with fatal error: \(error) - Will not try again")
                        completion(.failure(error))
                        return
                    }
                case let .generic(err):
                    if self?.isErrorFatal(err.code) == true || config.fatalStatusCodes.contains(error.code) {
                        self?.logger.log(text: "Request failed with fatal error: \(error) - Will not try again")
                        completion(.failure(error))
                        return
                    }
                default:
                    break
                }
                
                guard retryRemaining > 0 else {
                    self?.logger.log(text: "Request failed: \(error), \(retryRemaining) attempt/s left")
                    completion(.failure(error))
                    return
                }
                
                self?.logger.log(error: error)
                let delayTime: TimeInterval = request.delayTimeInterval(retryRemaining: retryRemaining, config: config)
                
                DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + delayTime, execute: { [weak self] in
                    self?.send(request: request, urlRequest: urlRequest, retryRemaining: retryRemaining - 1, config: config, completion: completion)
                })
            }
        }
        
        return task
    }
    
    private func send(urlRequest: URLRequest, completion: @escaping CompletionHandler) -> SessionCancellable? {
        let sessionDataTask = sessionManager.request(urlRequest) { data, response, requestError in
            
            if let requestError = requestError {
                var error: NetworkError
                
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
        }
        
        return sessionDataTask
    }
    
    private func isErrorFatal(_ code: Int) -> Bool {
        switch code {
        case let code where Constants.NetworkErrors.contains(Int32(code)):
            return true
            // 101 -> null address
        // 102 -> Ignore "Frame Load Interrupted" errors. Seen after app store links.
        case 101, 102:
            return true
        default:
            return false
        }
    }
}
