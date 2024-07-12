//
//  ResponseDecoder.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/14.
//

import Foundation

public protocol ResponseDecoder {
    func decode<T>(
        data: Data?,
        from request: T
    ) -> Result<T.Response, DataTransferError> where T : Requestable
}

public struct DefaultResponseDecoder: ResponseDecoder {
    private let errorLogger: DataErrorLogger
    
    public init() {
        self.errorLogger = DefaultDataErrorLogger()
    }
    
    public func decode<T>(
        data: Data?,
        from request: T
    ) -> Result<T.Response, DataTransferError> where T : Requestable {
        
        do {
            guard let data = data else { return .failure(.noResponse) }
            
            let result = try request.decoder.decode(T.Response.self, from: data)
            
            return .success(result)
        } catch {
            self.errorLogger.log(error: error)
            return .failure(.parsing(error))
        }
    }
}
