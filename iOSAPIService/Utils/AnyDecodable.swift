//
//  AnyDecodable.swift
//  iOSAPIService
//
//  Created by Thanh Nhut on 03/10/2023.
//

import Foundation

enum AnyDecodable: Decodable {
    
    case number(Double)
    case string(String)
    case none

    init(from decoder: Decoder) throws {
        if let doubleValue = try? decoder.singleValueContainer().decode(Double.self) {
            self = .number(doubleValue)
        } else if let stringValue = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(stringValue)
        } else {
            self = .none
        }
    }

    var valueAny: Any? {
        get {
            switch self {
            case .number(let value):
                return value
            case .string(let value):
                return value
            case .none:
                return nil
            }
        }
    }
}
