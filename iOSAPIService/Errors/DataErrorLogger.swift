//
//  DataErrorLogger.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/14.
//

import Foundation

protocol DataErrorLogger {
    func log(error: Error)
}

struct DefaultDataErrorLogger: DataErrorLogger {
    
    func log(error: Error) {
        if let _error = error as? DecodingError {
            log(error: _error)
        }
        
        printIfDebug("-------------")
        printIfDebug("\(error)")
    }
    
    private func log(error: DecodingError) {
        switch error {
        case DecodingError.keyNotFound(_, _):
            print("--- API Service Debug --- decode keyNotFound error \(error)")
            
        case DecodingError.typeMismatch(_, _):
            print("--- API Service Debug --- decode typeMismatch error \(error)")
            
        case DecodingError.valueNotFound(_, _):
            print("--- API Service Debug --- decode valueNotFound error \(error)")
            
        case DecodingError.dataCorrupted(_):
            print("--- API Service Debug --- decode dataCorrupted error \(error)")
            
        default:
            print("--- API Service Debug --- decode unexpectedResponse error \(error)")
        }
    }
}
