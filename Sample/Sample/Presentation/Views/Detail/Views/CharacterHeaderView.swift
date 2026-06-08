import SwiftUI

struct CharacterHeaderView: View {
    @ObservedObject var viewModel: CharacterHeaderViewModel

    var body: some View {
        VStack(spacing: 16) {
            CachedAsyncImage(url: viewModel.characterDTO.image.flatMap { URL(string: $0) })
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.characterDTO.name)
                    .font(.title2)
                    .fontWeight(.bold)

                HStack(spacing: 8) {
                    Circle()
                        .fill(viewModel.statusColor)
                        .frame(width: 10, height: 10)
                    Text(viewModel.characterDTO.status)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
