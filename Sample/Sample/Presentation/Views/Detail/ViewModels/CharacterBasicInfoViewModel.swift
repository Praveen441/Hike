import SwiftUI
import Combine

@MainActor
class CharacterBasicInfoViewModel: ObservableObject {
    let characterDTO: CharacterDTO

    init(characterDTO: CharacterDTO) {
        self.characterDTO = characterDTO
    }

    var speciesRow: DetailRowViewModel {
        DetailRowViewModel(basicInfoVM: self, field: .species)
    }

    var genderRow: DetailRowViewModel {
        DetailRowViewModel(basicInfoVM: self, field: .gender)
    }

    var originRow: DetailRowViewModel {
        DetailRowViewModel(basicInfoVM: self, field: .origin)
    }

    var locationRow: DetailRowViewModel {
        DetailRowViewModel(basicInfoVM: self, field: .location)
    }
}
