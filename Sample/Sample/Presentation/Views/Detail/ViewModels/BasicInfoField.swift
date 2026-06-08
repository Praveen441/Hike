import Foundation

enum BasicInfoField {
    case species
    case gender
    case origin
    case location

    var label: String {
        switch self {
        case .species:
            return "Species"
        case .gender:
            return "Gender"
        case .origin:
            return "Origin"
        case .location:
            return "Current Location"
        }
    }

    func value(from characterDTO: CharacterDTO) -> String {
        switch self {
        case .species:
            return characterDTO.species
        case .gender:
            return characterDTO.gender
        case .origin:
            return characterDTO.origin.name
        case .location:
            return characterDTO.location.name
        }
    }
}
