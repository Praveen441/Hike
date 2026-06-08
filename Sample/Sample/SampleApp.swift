import SwiftUI
import SwiftData

@main
struct SampleApp: App {
    private let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: CharacterEntity.self, EpisodeEntity.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            CharacterListView(
                viewModel: CharacterListViewModel(
                    characterService: CharacterServiceImpl(
                        repository: CharacterRepositoryImpl(
                            networkService: NetworkService(),
                            localDataSource: SwiftDataCharacterStore(modelContainer: container)
                        )
                    )
                )
            )
        }
    }
}
