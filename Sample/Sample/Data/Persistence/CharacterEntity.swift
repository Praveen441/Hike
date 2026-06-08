import Foundation
import SwiftData

@Model
final class CharacterEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var status: String
    var species: String
    var gender: String
    var originName: String
    var locationName: String
    var imageURL: String?
    var episodeURLs: [String]
    var sortIndex: Int

    init(
        id: Int,
        name: String,
        status: String,
        species: String,
        gender: String,
        originName: String,
        locationName: String,
        imageURL: String?,
        episodeURLs: [String],
        sortIndex: Int
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.originName = originName
        self.locationName = locationName
        self.imageURL = imageURL
        self.episodeURLs = episodeURLs
        self.sortIndex = sortIndex
    }
}

extension CharacterEntity {
    convenience init(character: RMCharacter, sortIndex: Int) {
        self.init(
            id: character.id,
            name: character.name,
            status: character.status.rawValue,
            species: character.species,
            gender: character.gender,
            originName: character.origin.name,
            locationName: character.location.name,
            imageURL: character.image?.absoluteString,
            episodeURLs: character.episodeURLs.map { $0.absoluteString },
            sortIndex: sortIndex
        )
    }

    func toDomain() -> RMCharacter {
        RMCharacter(
            id: id,
            name: name,
            status: CharacterStatus(rawValue: status) ?? .unknown,
            species: species,
            gender: gender,
            origin: Location(id: originName, name: originName, url: nil),
            location: Location(id: locationName, name: locationName, url: nil),
            image: imageURL.flatMap { URL(string: $0) },
            episodeURLs: episodeURLs.compactMap { URL(string: $0) }
        )
    }
}
