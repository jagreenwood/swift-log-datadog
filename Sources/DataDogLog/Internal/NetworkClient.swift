//
//  NetworkClient.swift
//
//
//  Created by Jeremy Greenwood on 2/1/24.
//

import Foundation
#if os(Linux)
import AsyncHTTPClient
import NIOCore
import NIOFoundationCompat
#endif

extension String: Error {}

@usableFromInline
final class NetworkClient: Sendable {
#if os(Linux)
    let client = HTTPClient(eventLoopGroupProvider: .singleton)
#else
    let client = URLSession.shared
#endif

    deinit {
#if os(Linux)
        try? client.syncShutdown()
#endif
    }

    @usableFromInline
    func send(_ log: Log, key: String, site: Site) async throws -> StatusCode {
        let logData = try JSONEncoder().encode(log)
        let headers: Dictionary<String, String> = [
            "Content-Type" : "application/json",
            "Accept" : "application/json",
            "DD-API-KEY" : key
        ]
#if os(Linux)
        var request = HTTPClientRequest(url: site.url.absoluteString)
        request.method = .POST
        request.body = .bytes(ByteBuffer(bytes: logData))
        
        for (key, value) in headers {
            request.headers.add(name: key, value: value)
        }

        let response = try await client.execute(request, timeout: .seconds(30))
        return StatusCode(value: Int(response.status.code))
#else
        var request = URLRequest(url: site.url)
        request.httpMethod = "POST"
        request.httpBody = logData

        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }

        let (_, response) = try await client.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw "Invalid Response"
        }

        return StatusCode(value: httpResponse.statusCode)
#endif
    }
}
