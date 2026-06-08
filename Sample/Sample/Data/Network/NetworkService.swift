import Foundation

extension URLError {
    var isNoNetworkError: Bool {
        switch code {
        case .notConnectedToInternet, .networkConnectionLost, .timedOut, .cannotConnectToHost:
            return true
        default:
            return false
        }
    }
}

enum NetworkError: LocalizedError {
    case invalidRequest
    case decodingError(Error)
    case httpError(Int)
    case unknown
    case noNetwork

    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "Invalid request"
        case .decodingError(let error):
            return "Failed to decode: \(error.localizedDescription)"
        case .httpError(let code):
            return "HTTP \(code)"
        case.noNetwork:
            return "No internet connection"
        case .unknown:
            return "Unknown error"
        }
    }
}

protocol NetworkServiceProtocol {
    nonisolated func execute<T: Decodable>(_ request: RequestBuilder) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    nonisolated func execute<T: Decodable>(_ request: RequestBuilder) async throws -> T {
        let urlRequest = try request.asURLRequest()
        guard let url = urlRequest.url else {
            throw NetworkError.invalidRequest
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            if let httpResponse = response as? HTTPURLResponse {
                throw NetworkError.httpError(httpResponse.statusCode)
            }
            throw NetworkError.unknown
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
