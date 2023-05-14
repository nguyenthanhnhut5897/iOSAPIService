//
//  ApiSessionConfigurationType.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/14.
//

import Foundation

public enum SessionConfigType: String {
    case `default`
    case ephemeral
}

public enum ApiSessionConfigurationType {
    /*
     The default session configuration uses a persistent disk-based cache (except when the result is downloaded to a file) and stores credentials in the user’s keychain. It also stores cookies (by default) in the same shared cookie store as the NSURLConnection and NSURLDownload classes.
     */
    case `default`
    /*
     An ephemeral session configuration object is similar to a default session configuration (see default), except that the corresponding session object doesn’t store caches, credential stores, or any session-related data to disk. Instead, session-related data is stored in RAM. The only time an ephemeral session writes data to disk is when you tell it to write the contents of a URL to a file.
     */
    case ephemeral
    case custom(NSURLRequest.CachePolicy, SessionConfigType)
}

