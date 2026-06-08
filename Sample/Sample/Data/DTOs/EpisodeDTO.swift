import Foundation

nonisolated struct EpisodeDTO: Decodable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode
    }

    nonisolated func toDomain() -> Episode {
        Episode(
            id: id,
            name: name,
            airDate: airDate,
            episode: episode
        )
    }
}
