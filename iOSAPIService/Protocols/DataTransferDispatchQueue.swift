//
//  DataTransferDispatchQueue.swift
//  iOSAPIService
//
//  Created by Thanh Nhut on 03/10/2023.
//

import Foundation

public protocol DataTransferDispatchQueue {
    func asyncExecute(work: @escaping () -> Void)
}

extension DispatchQueue: DataTransferDispatchQueue {
    public func asyncExecute(work: @escaping () -> Void) {
        async(group: nil, execute: work)
    }
}
