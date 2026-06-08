import Foundation
import Combine

@MainActor
class CharacterListViewModel: ObservableObject {
    @Published var characterRowVMs: [CharacterRowViewModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasMorePages = true

    private let characterService: CharacterService
    private var currentPage = 1
    private var totalPages = 1
    private var allCharacterRowVMs: [CharacterRowViewModel] = []

    init(characterService: CharacterService) {
        self.characterService = characterService
    }

    func loadInitialCharacters() {
        currentPage = 1
        allCharacterRowVMs = []
        characterRowVMs = []
        errorMessage = nil
        loadNextPage()
    }

    func loadNextPage() {
        guard !isLoading && hasMorePages else { return }

        Task {
            isLoading = true
            errorMessage = nil

            do {
                let response = try await characterService.fetchCharacters(page: currentPage, name: nil)
                let newVMs = response.results.map { CharacterRowViewModel(characterDTO: $0) }
                allCharacterRowVMs.append(contentsOf: newVMs)
                characterRowVMs.append(contentsOf: newVMs)
                totalPages = response.info.toDomain().pages
                currentPage += 1
                hasMorePages = currentPage <= totalPages
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }

    func filterCharacters(by searchText: String) {
        if searchText.isEmpty {
            characterRowVMs = allCharacterRowVMs
        } else {
            characterRowVMs = allCharacterRowVMs.filter { vm in
                vm.characterDTO.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    func retry() {
        loadInitialCharacters()
    }
}
