//
//  Constants.swift
//  iOSAPIService
//
//  Created by Nguyen Thanh Nhut on 2023/05/12.
//

import Foundation

struct Constants {
    static let CachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy
    static let TimeoutInterval: TimeInterval = 60.0 //60s
    static let RetryCount: Int = 3
    static let RetryTimeInterval: TimeInterval = 0
    static let AllowDelayProgressive: Bool = true
}

extension Constants {
    static let NetworkErrors: [Int32] = [
        CFNetworkErrors.cfHostErrorHostNotFound.rawValue,
        // Query the kCFGetAddrInfoFailureKey to get the value returned from getaddrinfo; lookup in netdb.h
        CFNetworkErrors.cfHostErrorUnknown.rawValue,
        // HTTP errors
        CFNetworkErrors.cfErrorHTTPAuthenticationTypeUnsupported.rawValue,
        CFNetworkErrors.cfErrorHTTPBadCredentials.rawValue,
        CFNetworkErrors.cfErrorHTTPParseFailure.rawValue,
        CFNetworkErrors.cfErrorHTTPRedirectionLoopDetected.rawValue,
        CFNetworkErrors.cfErrorHTTPBadURL.rawValue,
        CFNetworkErrors.cfErrorHTTPBadProxyCredentials.rawValue,
        CFNetworkErrors.cfErrorPACFileError.rawValue,
        CFNetworkErrors.cfErrorPACFileAuth.rawValue,
        CFNetworkErrors.cfStreamErrorHTTPSProxyFailureUnexpectedResponseToCONNECTMethod.rawValue,
        // Error codes for CFURLConnection and CFURLProtocol
        CFNetworkErrors.cfurlErrorUnknown.rawValue,
        CFNetworkErrors.cfurlErrorCancelled.rawValue,
        CFNetworkErrors.cfurlErrorBadURL.rawValue,
        CFNetworkErrors.cfurlErrorUnsupportedURL.rawValue,
        CFNetworkErrors.cfurlErrorHTTPTooManyRedirects.rawValue,
        CFNetworkErrors.cfurlErrorBadServerResponse.rawValue,
        CFNetworkErrors.cfurlErrorUserCancelledAuthentication.rawValue,
        CFNetworkErrors.cfurlErrorUserAuthenticationRequired.rawValue,
        CFNetworkErrors.cfurlErrorZeroByteResource.rawValue,
        CFNetworkErrors.cfurlErrorCannotDecodeRawData.rawValue,
        CFNetworkErrors.cfurlErrorCannotDecodeContentData.rawValue,
        CFNetworkErrors.cfurlErrorCannotParseResponse.rawValue,
        CFNetworkErrors.cfurlErrorInternationalRoamingOff.rawValue,
        CFNetworkErrors.cfurlErrorCallIsActive.rawValue,
        CFNetworkErrors.cfurlErrorDataNotAllowed.rawValue,
        CFNetworkErrors.cfurlErrorRequestBodyStreamExhausted.rawValue,
        CFNetworkErrors.cfurlErrorFileDoesNotExist.rawValue,
        CFNetworkErrors.cfurlErrorFileIsDirectory.rawValue,
        CFNetworkErrors.cfurlErrorNoPermissionsToReadFile.rawValue,
        CFNetworkErrors.cfurlErrorDataLengthExceedsMaximum.rawValue,
        // SSL errors
        CFNetworkErrors.cfurlErrorServerCertificateHasBadDate.rawValue,
        CFNetworkErrors.cfurlErrorServerCertificateUntrusted.rawValue,
        CFNetworkErrors.cfurlErrorServerCertificateHasUnknownRoot.rawValue,
        CFNetworkErrors.cfurlErrorServerCertificateNotYetValid.rawValue,
        CFNetworkErrors.cfurlErrorClientCertificateRejected.rawValue,
        CFNetworkErrors.cfurlErrorClientCertificateRequired.rawValue,
        CFNetworkErrors.cfurlErrorCannotLoadFromNetwork.rawValue,
        // Cookie errors
        CFNetworkErrors.cfhttpCookieCannotParseCookieFile.rawValue,
        // Errors originating from CFNetServices
        CFNetworkErrors.cfNetServiceErrorUnknown.rawValue,
        CFNetworkErrors.cfNetServiceErrorCollision.rawValue,
        CFNetworkErrors.cfNetServiceErrorNotFound.rawValue,
        CFNetworkErrors.cfNetServiceErrorInProgress.rawValue,
        CFNetworkErrors.cfNetServiceErrorBadArgument.rawValue,
        CFNetworkErrors.cfNetServiceErrorCancel.rawValue,
        CFNetworkErrors.cfNetServiceErrorInvalid.rawValue
    ]
}
