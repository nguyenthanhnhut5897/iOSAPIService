//
//  ErrorExtensions.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/08.
//

import Foundation

public extension Error {
    public var code: Int { return (self as NSError).code }
    public var domain: String { return (self as NSError).domain }
    public var userInfo: [String: Any] { return (self as NSError).userInfo }
    public var localizedDescription: String { return (self as NSError).localizedDescription }
}
