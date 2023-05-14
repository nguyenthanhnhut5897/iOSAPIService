//
//  ApiServiceProtocol.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/13.
//

import Foundation

protocol ApiServiceProtocol {
    typealias CompletionHandler<E> = (Result<E, DataTransferError>) -> Void
    
    @discardableResult
    func send<E, T>(
        with request: T,
        completion: @escaping CompletionHandler<E>
    ) -> SessionCancellable? where E : Decodable, E == T.Response, T : Requestable
    
    @discardableResult
    func send<E, T>(
        with request: T,
        completion: @escaping CompletionHandler<E>
    ) -> SessionCancellable? where E : Any, E == T.Response, T : Requestable
    
    @discardableResult
    func send<E, T, C>(
        with request: T,
        config: C,
        completion: @escaping CompletionHandler<E>
    ) -> SessionCancellable? where E : Decodable, E == T.Response, T : Requestable, C : ApiConfigurable
    
    @discardableResult
    func send<E, T, C>(
        with request: T,
        config: C,
        completion: @escaping CompletionHandler<E>
    ) -> SessionCancellable? where E : Any, E == T.Response, T : Requestable, C : ApiConfigurable
}
