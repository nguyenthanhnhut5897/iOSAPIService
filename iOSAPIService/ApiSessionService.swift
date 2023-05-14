//
//  ApiSessionService.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/13.
//

import Foundation

public protocol ApiSessionService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
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

struct DefaultApiSessionService {
    
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
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

extension DefaultApiSessionService: ApiSessionService {
    func send<T, C>(request: T, config: C, completion: @escaping CompletionHandler) -> SessionCancellable? where T : Requestable, C : ApiConfigurable {
        guard let urlRequest = request.makeURLRequest(with: config) else {
            completion(.failure(.urlGeneration))
            return nil
        }
        
        let sessionDataTask = sessionManager.request(urlRequest) { data, response, requestError in
            
            if let requestError = requestError {
                var error: NetworkError
                
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
                self.logger.log(responseData: data, response: response)
                completion(.success(data))
            }
        }
    
        logger.log(request: urlRequest)

        return sessionDataTask
    }
    
    @discardableResult
    func send<T>(request: T, completion: @escaping CompletionHandler) -> SessionCancellable? where T : Requestable {
        guard let urlRequest = request.makeURLRequest() else {
            completion(.failure(.urlGeneration))
            return nil
        }
            
        let sessionDataTask = sessionManager.request(urlRequest) { data, response, requestError in
            
            if let requestError = requestError {
                var error: NetworkError
                
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
                self.logger.log(responseData: data, response: response)
                completion(.success(data))
            }
        }
    
        logger.log(request: urlRequest)

        return sessionDataTask
    }
}
