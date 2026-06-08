import SwiftUI
import Combine

@MainActor
class CharacterRowViewModel: ObservableObject {
    let characterDTO: CharacterDTO

    init(characterDTO: CharacterDTO) {
        self.characterDTO = characterDTO
    }

    var statusColor: Color {
        switch characterDTO.status {
        case "Alive":
            return .green
        case "Dead":
            return .red
        default:
            return .gray
        }
    }
}
