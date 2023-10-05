//
//  ApiServiceProtocol.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/13.
//

import Foundation

public protocol ApiServiceProtocol {
    typealias CompletionHandler<E> = (Result<E, DataTransferError>, Data?) -> Void
    
    @discardableResult
    func send<E, T>(
        with request: T,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<E>
    ) -> SessionCancellable? where E : Decodable, E == T.Response, T : Requestable
    
    @discardableResult
    func send<E, T, C>(
        with request: T,
        config: C,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<E>
    ) -> SessionCancellable? where E : Decodable, E == T.Response, T : Requestable, C : ApiConfigurable
}
