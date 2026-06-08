import SwiftUI

struct CharacterRowView: View {
    @ObservedObject var viewModel: CharacterRowViewModel

    init(viewModel: CharacterRowViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack(spacing: 12) {
            CachedAsyncImage(url: viewModel.characterDTO.image.flatMap { URL(string: $0) })
                .frame(width: 60, height: 60)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.characterDTO.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text(viewModel.characterDTO.species)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Circle()
                        .fill(viewModel.statusColor)
                        .frame(width: 8, height: 8)

                    Text(viewModel.characterDTO.status)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    let characterDTO = CharacterDTO(
        id: 1,
        name: "Rick Sanchez",
        status: "Alive",
        species: "Human",
        gender: "Male",
        origin: LocationDTO(name: "Earth", url: ""),
        location: LocationDTO(name: "Earth", url: ""),
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episode: []
    )
    CharacterRowView(viewModel: CharacterRowViewModel(characterDTO: characterDTO))
}
