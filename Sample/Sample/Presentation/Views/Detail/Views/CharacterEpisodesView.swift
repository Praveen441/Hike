import SwiftUI

struct CharacterEpisodesView: View {
    @ObservedObject var viewModel: CharacterEpisodesViewModel

    var body: some View {
        if viewModel.hasEpisodes {
            DetailSection(title: "Episodes") {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(viewModel.episodeDTOs.enumerated()), id: \.element.id) { index, episode in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(episode.name)
                                .font(.caption)
                                .fontWeight(.semibold)
                            Text("Season \(episode.episode)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Text(episode.airDate)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 8)
                        if index < viewModel.episodeDTOs.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }
}
