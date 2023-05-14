//
//  DataErrorLogger.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/14.
//

import Foundation

public protocol DataErrorLogger {
    func log(error: Error)
}

public struct DefaultDataErrorLogger: DataErrorLogger {
    public init() {}
    
    public func log(error: Error) {
        printIfDebug("-------------")
        printIfDebug("\(error)")
    }
}
