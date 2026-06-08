import Foundation

enum RMEndpoint: RequestBuilder {
    case fetchCharacters(page: Int)
    case fetchCharacter(id: Int)
    case fetchEpisode(url: URL)

    var baseURL: URL {
        URL(string: "https://rickandmortyapi.com/api")!
    }

    var path: String {
        switch self {
        case .fetchCharacters:
            return "character"
            
        case .fetchCharacter(let id):
            return "character/\(id)"
            
        case .fetchEpisode(let url):
            return url.path
        }
    }

    var httpMethod: RequestHTTPMethod {
        return .GET
    }

    var parameters: RequestParameters? {
        switch self {
        case .fetchCharacters(let page):
            return ["page": page]
            
        case .fetchCharacter, .fetchEpisode:
            return nil
        }
    }

    var headers: RequestHeaders? {
        return nil
    }

    var encoding: RequestEncoder {
        URLParameterEncoder()
    }

    var requestURL: URL {
        switch self {
        case .fetchEpisode(let url):
            return url
        default:
            var url = baseURL
            if !path.isEmpty {
                url = url.appendingPathComponent(path)
            }
            return URL(string: url.absoluteString.removingPercentEncoding ?? url.absoluteString) ?? url
        }
    }

    nonisolated func asURLRequest() throws -> URLRequest {
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
