import Foundation
@testable import Sample

class MockNetworkService: NetworkServiceProtocol {
    var mockResponse: CharacterResponseDTO?
    var mockCharacterDTO: CharacterDTO?
    var mockEpisodeDTOs: [EpisodeDTO]?
    var shouldFail = false

    nonisolated func execute<T: Decodable>(_ request: RequestBuilder) async throws -> T {
        if shouldFail {
            throw NSError(domain: "Test", code: -1, userInfo: nil)
        }

        if T.self == CharacterResponseDTO.self {
            guard let result = (mockResponse ?? CharacterResponseDTO(
                info: PageInfoDTO(count: 0, pages: 0, next: nil, prev: nil),
                results: []
            )) as? T else {
                throw NSError(domain: "Test", code: -1, userInfo: nil)
            }
            return result
        } else if T.self == CharacterDTO.self {
            guard let result = (mockCharacterDTO ?? CharacterDTO(
                id: 0, name: "", status: "", species: "", gender: "",
                origin: LocationDTO(name: "", url: ""),
                location: LocationDTO(name: "", url: ""),
                image: nil, episode: []
            )) as? T else {
                throw NSError(domain: "Test", code: -1, userInfo: nil)
            }
            return result
        } else if T.self == EpisodeDTO.self {
            guard let result = (mockEpisodeDTOs?.first ?? EpisodeDTO(
                id: 0, name: "", airDate: "", episode: ""
            )) as? T else {
                throw NSError(domain: "Test", code: -1, userInfo: nil)
            }
            return result
        }

        throw NSError(domain: "Test", code: -1, userInfo: nil)
    }
}
