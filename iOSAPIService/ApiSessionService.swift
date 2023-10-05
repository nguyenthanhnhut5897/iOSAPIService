//
//  ApiSessionService.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/13.
//

import Foundation

protocol ApiSessionService {
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
    
    private func resolve(errorData: Data?) -> NetworkError {
        guard let errorData = errorData else { return .dataNotFound }
        
        do {
            let errJson = try JSONSerialization.jsonObject(with: errorData, options: .allowFragments)
            let json = errJson as? [String: Any]
            let code = (json?["status"] as? Int) ?? 0
            
            //print error json object if data is serializable
            self.logger.log(errJson)
                
            return .error(statusCode: code, data: errorData, json: json)
            
        } catch let serializationError {
            return .generic(serializationError)
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
        logger.log(urlRequest.cURL(pretty: true))
        
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
                case let .error(code, _, _):
                    if self?.isErrorFatal(code) == true || config.fatalStatusCodes.contains(error.code) {
                        self?.logger.log("Request failed with fatal error: \(error) - Will not try again")
                        completion(.failure(error))
                        return
                    }
                case let .generic(err):
                    if self?.isErrorFatal(err.code) == true || config.fatalStatusCodes.contains(error.code) {
                        self?.logger.log("Request failed with fatal error: \(error) - Will not try again")
                        completion(.failure(error))
                        return
                    }
                default:
                    break
                }
                
                guard retryRemaining > 0 else {
                    self?.logger.log("Request failed: \(error), \(retryRemaining) attempt/s left")
                    completion(.failure(error))
                    return
                }
                
                self?.logger.log(error: error)
                self?.logger.log("------\(retryRemaining - 1) attempt/s left -----")
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
                    error = .error(statusCode: response.statusCode, data: data, json: nil)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                completion(.failure(error))
            }
            // To successfully decode to T.Response.self, the status code must not between 0 and 299
            else if let httpResponse = response as? HTTPURLResponse, !(0..<300).contains(httpResponse.statusCode) {
                let error: NetworkError = self.resolve(errorData: data)
                
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
