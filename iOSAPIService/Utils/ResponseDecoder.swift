//
//  ResponseDecoder.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/14.
//

import Foundation

public protocol ResponseDecoder {
    func decode<E, T>(
        data: Data?,
        from request: T
    ) -> Result<E, DataTransferError> where E : Decodable, T : Requestable, E == T.Response
}

public struct DefaultResponseDecoder: ResponseDecoder {
    public init() {}
    
    public func decode<E, T>(
        data: Data?,
        from request: T
    ) -> Result<E, DataTransferError> where E : Decodable, T : Requestable, E == T.Response {
        
        do {
            guard let data = data else { return .failure(.noResponse) }
            
            let result = try request.decoder.decode(E.self, from: data)
            
            return .success(result)
        } catch {
            return .failure(.parsing(error))
        }
    }
}
