//
//  StatusCode.swift
//
//
//  Created by Jeremy Greenwood on 2/2/24.
//

import Foundation

@usableFromInline
enum StatusCode: CustomStringConvertible, Sendable {
    case accepted
    case badRequest
    case unauthorized
    case permissionIssue
    case requestTimeout
    case payloadToolarge
    case tooManyRequests
    case internalServerError
    case serviceUnavailable

    init(value: Int) {
        switch value {
        case 202: self = .accepted
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 403: self = .permissionIssue
        case 408: self = .requestTimeout
        case 413: self = .payloadToolarge
        case 429: self = .tooManyRequests
        case 500: self = .internalServerError
        case 503: self = .serviceUnavailable
        default: self = .serviceUnavailable
        }
    }

    var rawValue: Int {
        switch self {
        case .accepted: 202
        case .badRequest: 400
        case .unauthorized: 401
        case .permissionIssue: 403
        case .requestTimeout: 408
        case .payloadToolarge: 413
        case .tooManyRequests: 429
        case .internalServerError: 500
        case .serviceUnavailable: 503
        }
    }

    @usableFromInline
    var success: Bool {
        self == .accepted
    }

    @usableFromInline
    var description: String {
        switch self {
        case .accepted:
            "Accepted: the request has been accepted for processing"
        case .badRequest:
            "Bad request (likely an issue in the payload formatting)"
        case .unauthorized:
            "Unauthorized (likely a missing API Key)"
        case .permissionIssue:
            "Permission issue (likely using an invalid API Key)"
        case .requestTimeout:
            "Request Timeout, request should be retried after some time"
        case .payloadToolarge:
            "Payload too large (batch is above 5MB uncompressed)"
        case .tooManyRequests:
            "Too Many Requests, request should be retried after some time"
        case .internalServerError:
            "Internal Server Error, the server encountered an unexpected condition that prevented it from fulfilling the request, request should be retried after some time"
        case .serviceUnavailable:
            "Service Unavailable, the server is not ready to handle the request probably because it is overloaded, request should be retried after some time"
        }
    }
}
