//
//  ApiService.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/13.
//

import Foundation

public class ApiService {
    public static let shared = ApiService()
    
    private let apiSessionService: ApiSessionService
    private let decoder: ResponseDecoder
    private let errorResolver: DataErrorResolver
    private let errorLogger: DataErrorLogger
    
    private init() {
        let sessionManager = DefaultApiSessionManager(with: .default)
        self.apiSessionService = DefaultApiSessionService(sessionManager: sessionManager)
        self.decoder = DefaultResponseDecoder()
        self.errorResolver = DefaultDataErrorResolver()
        self.errorLogger = DefaultDataErrorLogger()
    }
    
    public init(with configType: ApiSessionConfigurationType) {
        let sessionManager = DefaultApiSessionManager(with: configType)
        self.apiSessionService = DefaultApiSessionService(sessionManager: sessionManager)
        self.decoder = DefaultResponseDecoder()
        self.errorResolver = DefaultDataErrorResolver()
        self.errorLogger = DefaultDataErrorLogger()
    }
    
    public init(with apiSessionService: ApiSessionService,
                decoder: ResponseDecoder = DefaultResponseDecoder(),
                errorResolver: DataErrorResolver = DefaultDataErrorResolver(),
                errorLogger: DataErrorLogger = DefaultDataErrorLogger()) {
        self.apiSessionService = apiSessionService
        self.decoder = decoder
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        
        return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
    }
}

extension ApiService: ApiServiceProtocol {
    func send<E, T>(with request: T, completion: @escaping CompletionHandler<E>) -> SessionCancellable? where E : Decodable, E == T.Response, T : Requestable {
        
        return apiSessionService.send(request: request) { result in
            switch result {
            case .success(let data):
                let result: Result<E, DataTransferError> = self.decoder.decode(data: data, from: request)
                
                completion(result)
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                completion(.failure(error))
            }
        }
    }
    
    func send<E, T>(with request: T, completion: @escaping CompletionHandler<E>) -> SessionCancellable? where E == T.Response, T : Requestable {
        return URLSessionTask()
    }
    
    func send<E, T, C>(with request: T, config: C, completion: @escaping CompletionHandler<E>) -> SessionCancellable? where E : Decodable, E == T.Response, T : Requestable, C : ApiConfigurable {
        return URLSessionTask()
    }
    
    func send<E, T, C>(with request: T, config: C, completion: @escaping CompletionHandler<E>) -> SessionCancellable? where E == T.Response, T : Requestable, C : ApiConfigurable {
        return URLSessionTask()
    }
}