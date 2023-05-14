//
//  DataTransferError.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/13.
//

import Foundation

public enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}
