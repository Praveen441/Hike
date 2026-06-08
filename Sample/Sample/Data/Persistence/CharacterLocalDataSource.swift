import Foundation
import SwiftData

protocol CharacterLocalDataSource: Sendable {
    func saveCharacters(_ characters: [RMCharacter]) async
    func loadCharacters() async -> [RMCharacter]
    func saveEpisodes(_ episodes: [Episode]) async
    func loadEpisodes() async -> [Episode]
}

@ModelActor
actor SwiftDataCharacterStore: CharacterLocalDataSource {
    func saveCharacters(_ characters: [RMCharacter]) async {
        do {
            let descriptor = FetchDescriptor<CharacterEntity>()
            let cached = (try? modelContext.fetch(descriptor)) ?? []
            let cachedIds = Set(cached.map { $0.id })

            for character in characters {
                if !cachedIds.contains(character.id) {
                    modelContext.insert(CharacterEntity(character: character, sortIndex: 0))
                }
            }
            try modelContext.save()
        } catch {
        }
    }

    func loadCharacters() async -> [RMCharacter] {
        let descriptor = FetchDescriptor<CharacterEntity>(
            sortBy: [SortDescriptor(\.name)]
        )
        let entities = (try? modelContext.fetch(descriptor)) ?? []
        return entities.map { $0.toDomain() }
    }

    func saveEpisodes(_ episodes: [Episode]) async {
        do {
            let descriptor = FetchDescriptor<EpisodeEntity>()
            let cached = (try? modelContext.fetch(descriptor)) ?? []
            let cachedIds = Set(cached.map { $0.id })

            for episode in episodes {
                if !cachedIds.contains(episode.id) {
                    modelContext.insert(EpisodeEntity(episode: episode))
                }
            }
            try modelContext.save()
        } catch {
        }
    }

    func loadEpisodes() async -> [Episode] {
        let descriptor = FetchDescriptor<EpisodeEntity>(
            sortBy: [SortDescriptor(\.name)]
        )
        let entities = (try? modelContext.fetch(descriptor)) ?? []
        return entities.map { $0.toDomain() }
    }
}
