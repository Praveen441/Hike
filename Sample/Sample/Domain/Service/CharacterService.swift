import Foundation

protocol CharacterService {
    nonisolated func fetchCharacters(page: Int, name: String?) async throws -> CharacterResponseDTO
    nonisolated func fetchCharacterDetail(id: Int) async throws -> (character: CharacterDTO, episodes: [EpisodeDTO])
}

class CharacterServiceImpl: CharacterService {
    private let repository: CharacterRepository

    init(repository: CharacterRepository) {
        self.repository = repository
    }

    nonisolated func fetchCharacters(page: Int, name: String? = nil) async throws -> CharacterResponseDTO {
        let response = try await repository.fetchCharacters(page: page)

        if let name = name, !name.isEmpty {
            let filtered = response.results.filter { char in
                char.name.localizedCaseInsensitiveContains(name)
            }
            return CharacterResponseDTO(info: response.info, results: filtered)
        }

        return response
    }

    nonisolated func fetchCharacterDetail(id: Int) async throws -> (character: CharacterDTO, episodes: [EpisodeDTO]) {
        let character = try await repository.fetchCharacter(id: id)
        let episodes = try await repository.fetchEpisodes(urls: character.episode.compactMap { URL(string: $0) })
        return (character, episodes)
    }
}
