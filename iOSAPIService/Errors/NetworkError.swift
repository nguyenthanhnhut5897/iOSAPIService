//
//  NetworkError.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/13.
//

import Foundation

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}
