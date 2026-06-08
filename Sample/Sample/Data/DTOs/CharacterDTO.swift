import Foundation

nonisolated struct CharacterResponseDTO: Decodable {
    let info: PageInfoDTO
    let results: [CharacterDTO]
}

nonisolated struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: LocationDTO
    let location: LocationDTO
    let image: String?
    let episode: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, status, species, gender, origin, location, image, episode
    }

    nonisolated func toDomain() -> RMCharacter {
        RMCharacter(
            id: id,
            name: name,
            status: CharacterStatus(rawValue: status) ?? .unknown,
            species: species,
            gender: gender,
            origin: origin.toDomain(),
            location: location.toDomain(),
            image: image.flatMap { URL(string: $0) },
            episodeURLs: episode.compactMap { URL(string: $0) }
        )
    }
}

nonisolated struct LocationDTO: Decodable {
    let name: String
    let url: String

    nonisolated func toDomain() -> Location {
        let id = url.split(separator: "/").last.map(String.init) ?? UUID().uuidString
        return Location(
            id: id,
            name: name,
            url: URL(string: url)
        )
    }
}

nonisolated struct PageInfoDTO: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?

    nonisolated func toDomain() -> PageInfo {
        PageInfo(
            count: count,
            pages: pages,
            next: next.flatMap { URL(string: $0) },
            prev: prev.flatMap { URL(string: $0) }
        )
    }
}
