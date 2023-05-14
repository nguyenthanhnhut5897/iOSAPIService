//
//  ResponseError.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/08.
//

import Foundation

public enum ResponseError: Error {
    case unacceptableCode(Int)
    case unexpectedResponse(Any)
}
