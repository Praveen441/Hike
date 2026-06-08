import SwiftUI

struct CharacterBasicInfoView: View {
    @ObservedObject var viewModel: CharacterBasicInfoViewModel

    var body: some View {
        DetailSection(title: "Basic Info") {
            DetailRow(viewModel: viewModel.speciesRow)
            DetailRow(viewModel: viewModel.genderRow)
            DetailRow(viewModel: viewModel.originRow)
            DetailRow(viewModel: viewModel.locationRow)
        }
    }
}
