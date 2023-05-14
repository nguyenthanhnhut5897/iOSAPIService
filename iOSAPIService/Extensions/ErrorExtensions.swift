//
//  ErrorExtensions.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/08.
//

import Foundation

public extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
    var userInfo: [String: Any] { return (self as NSError).userInfo }
    var localizedDescription: String { return (self as NSError).localizedDescription }
}
