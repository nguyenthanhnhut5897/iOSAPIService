//
//  APIDateFormatter.swift
//  iOSAPIService
//
//  Created by Thanh Nhut on 04/10/2023.
//

import Foundation

public struct APIDateFormat {
    public static let `default` = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
}

public class APIDateFormatter {
    public static let shared: APIDateFormatter = APIDateFormatter()
    
    private var cache: [String: DateFormatter] = [:]
    private init() {}
    
    private func dateFormatter(from dateFormat: String, identifier: Calendar.Identifier = .gregorian) -> DateFormatter {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if let formatter = cache[dateFormat] {
            return formatter
        }
        
        let formatter = DateFormatter()
        let calendar = Calendar(identifier: identifier)
        formatter.dateFormat = dateFormat
        formatter.timeZone = calendar.timeZone
        formatter.locale = calendar.locale
        
        cache[dateFormat] = formatter
        
        return formatter
    }
    
    public func formatter(for format: String, identifier: Calendar.Identifier = .gregorian) -> DateFormatter {
        return dateFormatter(from: format, identifier: identifier)
    }
    
    public func remove(formatter: String) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        cache.removeValue(forKey: formatter)
    }
    
    public func removeAll() {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        cache.removeAll()
    }
}
