import SwiftUI
import Combine

@MainActor
class DetailRowViewModel: ObservableObject {
    let basicInfoVM: CharacterBasicInfoViewModel
    let field: BasicInfoField

    init(basicInfoVM: CharacterBasicInfoViewModel, field: BasicInfoField) {
        self.basicInfoVM = basicInfoVM
        self.field = field
    }

    var displayLabel: String {
        field.label
    }

    var displayValue: String {
        field.value(from: basicInfoVM.characterDTO)
    }
}
