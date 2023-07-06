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
    private let errorLogger: DataErrorLogger
    
    public init() {
        self.errorLogger = DefaultDataErrorLogger()
    }
    
    public func decode<E, T>(
        data: Data?,
        from request: T
    ) -> Result<E, DataTransferError> where E : Decodable, T : Requestable, E == T.Response {
        
        do {
            guard let data = data else { return .failure(.noResponse) }
            
            let result = try request.decoder.decode(E.self, from: data)
            
            return .success(result)
        } catch {
            self.errorLogger.log(error: error)
            return .failure(.parsing(error))
        }
    }
}
