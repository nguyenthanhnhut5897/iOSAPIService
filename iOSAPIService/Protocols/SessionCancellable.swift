//
//  SessionCancellable.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/13.
//

import Foundation

public protocol SessionCancellable {
    func cancel()
}

extension URLSessionTask: SessionCancellable { }
