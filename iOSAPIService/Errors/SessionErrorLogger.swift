//
//  SessionErrorLogger.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/13.
//

import Foundation

protocol SessionErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
    func log(text: String)
}

struct DefaultSessionErrorLogger: SessionErrorLogger {
    func log(request: URLRequest) {
        print("-------------")
        print("request: \(String(describing: request.url))")
        print("headers: \(String(describing: request.allHTTPHeaderFields))")
        print("method: \(String(describing: request.httpMethod))")
        
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }

    func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }

    func log(error: Error) {
        printIfDebug("Request failed: \(error)")
    }
    
    func log(text: String) {
        printIfDebug(text)
    }
}

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}
