import Foundation
import Combine

@MainActor
class CharacterDetailViewModel: ObservableObject {
    @Published var headerViewModel: CharacterHeaderViewModel?
    @Published var basicInfoViewModel: CharacterBasicInfoViewModel?
    @Published var episodesViewModel: CharacterEpisodesViewModel?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let characterService: CharacterService
    private let characterId: Int

    init(characterId: Int, characterService: CharacterService) {
        self.characterId = characterId
        self.characterService = characterService
    }

    func loadCharacterDetail() {
        Task {
            isLoading = true
            errorMessage = nil

            do {
                let result = try await characterService.fetchCharacterDetail(id: characterId)
                self.headerViewModel = CharacterHeaderViewModel(characterDTO: result.character)
                self.basicInfoViewModel = CharacterBasicInfoViewModel(characterDTO: result.character)
                self.episodesViewModel = CharacterEpisodesViewModel(episodeDTOs: result.episodes)
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }

    func retry() {
        loadCharacterDetail()
    }
}
