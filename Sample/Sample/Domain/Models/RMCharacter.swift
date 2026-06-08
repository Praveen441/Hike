import Foundation

struct RMCharacter: Identifiable, Equatable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let gender: String
    let origin: Location
    let location: Location
    let image: URL?
    let episodeURLs: [URL]
}

enum CharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

struct Location: Identifiable, Equatable {
    let id: String
    let name: String
    let url: URL?

    var path: String? {
        url?.pathComponents.last
    }
}

struct CharacterPage: Equatable {
    let characters: [RMCharacter]
    let info: PageInfo
}

struct PageInfo: Equatable {
    let count: Int
    let pages: Int
    let next: URL?
    let prev: URL?
}
