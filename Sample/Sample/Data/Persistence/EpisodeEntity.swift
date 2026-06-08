import Foundation
import SwiftData

@Model
final class EpisodeEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var airDate: String
    var episode: String

    init(id: Int, name: String, airDate: String, episode: String) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.episode = episode
    }
}

extension EpisodeEntity {
    convenience init(episode: Episode) {
        self.init(
            id: episode.id,
            name: episode.name,
            airDate: episode.airDate,
            episode: episode.episode
        )
    }

    func toDomain() -> Episode {
        Episode(
            id: id,
            name: name,
            airDate: airDate,
            episode: episode
        )
    }
}
