import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

typealias StatusCode = Int

protocol Session {
    func send(_ log: Log, key: String, region: Region, handler: @escaping (Result<StatusCode, Error>) -> ())
}

extension String: Error {}
extension Optional: Error where Wrapped == String {}

extension URLSession: Session {
    func send(_ log: Log, key: String, region: Region, handler: @escaping (Result<StatusCode, Error>) -> ()) {
        do {
            let data = try JSONEncoder().encode(log)

            var request = URLRequest(url: region.getURL())
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(key, forHTTPHeaderField: "DD-API-KEY")

            let task = dataTask(with: request) {data, response, error in
                if let error = error {
                    handler(.failure(error))
                } else if let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) {
                    handler(.success(httpResponse.statusCode))
                } else {
                    handler(.failure(data.flatMap{ String(data: $0, encoding: .utf8) ?? "Invalid Response" }))
                }
            }

            task.resume()
        } catch {
            handler(.failure(error))
        }
    }
}
