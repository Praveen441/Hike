
import SwiftUI
import Combine

@MainActor
class CharacterEpisodesViewModel: ObservableObject {
    let episodeDTOs: [EpisodeDTO]

    init(episodeDTOs: [EpisodeDTO]) {
        self.episodeDTOs = episodeDTOs
    }

    var hasEpisodes: Bool {
        !episodeDTOs.isEmpty
    }
}
