import Foundation

protocol CharacterRepository {
    nonisolated func fetchCharacters(page: Int) async throws -> CharacterResponseDTO
    nonisolated func fetchCharacter(id: Int) async throws -> CharacterDTO
    nonisolated func fetchEpisodes(urls: [URL]) async throws -> [EpisodeDTO]
}

class CharacterRepositoryImpl: CharacterRepository {
    private let networkService: NetworkServiceProtocol
    private let localDataSource: CharacterLocalDataSource?

    init(networkService: NetworkServiceProtocol, localDataSource: CharacterLocalDataSource? = nil) {
        self.networkService = networkService
        self.localDataSource = localDataSource
    }

    nonisolated func fetchCharacters(page: Int) async throws -> CharacterResponseDTO {
        let endpoint = RMEndpoint.fetchCharacters(page: page)

        do {
            let response: CharacterResponseDTO = try await networkService.execute(endpoint)
            let characters = response.results.map { $0.toDomain() }
            await localDataSource?.saveCharacters(characters)
            return response
        } catch let error as URLError where error.isNoNetworkError {
            let cached = await localDataSource?.loadCharacters() ?? []
            if !cached.isEmpty {
                return CharacterResponseDTO(
                    info: PageInfoDTO(count: cached.count, pages: 1, next: nil, prev: nil),
                    results: cached.map { char in
                        CharacterDTO(
                            id: char.id, name: char.name, status: char.status.rawValue,
                            species: char.species, gender: char.gender,
                            origin: LocationDTO(name: char.origin.name, url: ""),
                            location: LocationDTO(name: char.location.name, url: ""),
                            image: char.image?.absoluteString, episode: char.episodeURLs.map { $0.absoluteString }
                        )
                    }
                )
            }
            throw NetworkError.noNetwork
        } catch {
            throw NetworkError.unknown
        }
    }

    nonisolated func fetchCharacter(id: Int) async throws -> CharacterDTO {
        let endpoint = RMEndpoint.fetchCharacter(id: id)
        return try await networkService.execute(endpoint)
    }

    nonisolated func fetchEpisodes(urls: [URL]) async throws -> [EpisodeDTO] {
        do {
            let dtos = try await withThrowingTaskGroup(of: EpisodeDTO.self) { group in
                for url in urls {
                    group.addTask {
                        let endpoint = RMEndpoint.fetchEpisode(url: url)
                        return try await self.networkService.execute(endpoint)
                    }
                }
                var results: [EpisodeDTO] = []
                for try await dto in group {
                    results.append(dto)
                }
                return results
            }
            let sorted = dtos.sorted { $0.id < $1.id }
            await localDataSource?.saveEpisodes(sorted.map { $0.toDomain() })
            return sorted
        } catch let error as URLError where error.isNoNetworkError {
            let cached = await localDataSource?.loadEpisodes() ?? []
            if !cached.isEmpty {
                return cached.map { ep in
                    EpisodeDTO(id: ep.id, name: ep.name, airDate: ep.airDate, episode: ep.episode)
                }
            }
            throw NetworkError.noNetwork
        } catch {
            throw NetworkError.unknown
        }
    }
}
