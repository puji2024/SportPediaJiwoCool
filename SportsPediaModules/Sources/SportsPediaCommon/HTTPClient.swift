import Foundation

public protocol HTTPClient: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPClient {}

public enum HTTPClientError: LocalizedError, Equatable {
    case invalidResponse
    case unsuccessfulStatusCode(Int)

    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            "Invalid server response."
        case let .unsuccessfulStatusCode(code):
            "The server returned HTTP \(code)."
        }
    }
}
