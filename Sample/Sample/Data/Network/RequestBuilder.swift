import Foundation

public enum RequestHTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

typealias RequestParameters = [String: Any]
typealias RequestHeaders = [String: String]

protocol RequestBuilder {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: RequestHTTPMethod { get }
    var parameters: RequestParameters? { get }
    var headers: RequestHeaders? { get }
    var encoding: RequestEncoder { get }
    var isDefaultParamsRequired: Bool { get }
    var requestURL: URL { get }

    func asURLRequest() throws -> URLRequest
}

extension RequestBuilder {
    var requestURL: URL {
        var url = baseURL
        
        if !path.isEmpty {
            url = url.appendingPathComponent(path)
            return URL(string: url.absoluteString.removingPercentEncoding ?? url.absoluteString) ?? url
        }
        return url
    }

    var isDefaultParamsRequired: Bool {
        return false
    }

    var headers: RequestHeaders? {
        return nil
    }

    var parameters: RequestParameters? {
        return nil
    }

    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue

        if let headers = headers {
            headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        }

        if let parameters = parameters {
            try encoding.encode(urlRequest: &request, with: parameters)
        }

        return request
    }
}

protocol RequestEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: RequestParameters) throws
}

struct URLParameterEncoder: RequestEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: RequestParameters) throws {
        guard let url = urlRequest.url else {
            throw NSError(domain: "Invalid URL", code: -1)
        }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
           !parameters.isEmpty {
            var queryItems = urlComponents.queryItems ?? []

            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                queryItems.append(queryItem)
            }

            urlComponents.queryItems = queryItems
            urlRequest.url = urlComponents.url
        }
    }
}

struct JSONParameterEncoder: RequestEncoder {
    private static let CONTENT_TYPE = "Content-Type"
    private static let CONTENT_TYPE_JSON = "application/json"

    func encode(urlRequest: inout URLRequest, with parameters: RequestParameters) throws {
        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        urlRequest.httpBody = jsonData

        if urlRequest.value(forHTTPHeaderField: Self.CONTENT_TYPE) == nil {
            urlRequest.setValue(Self.CONTENT_TYPE_JSON, forHTTPHeaderField: Self.CONTENT_TYPE)
        }
    }
}
