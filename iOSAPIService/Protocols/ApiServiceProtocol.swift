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
    func send<T>(
        with request: T,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<T.Response>
    ) -> SessionCancellable? where T : Requestable
    
    @discardableResult
    func send<T, C>(
        with request: T,
        config: C,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<T.Response>
    ) -> SessionCancellable? where T : Requestable, C : ApiConfigurable
}
