import SwiftUI

struct CharacterDetailView: View {
    let characterId: Int
    @StateObject private var viewModel: CharacterDetailViewModel
    @Environment(\.dismiss) var dismiss

    init(characterId: Int) {
        self.characterId = characterId
        let networkService = NetworkService()
        let repository = CharacterRepositoryImpl(networkService: networkService)
        let characterService = CharacterServiceImpl(repository: repository)
        
        _viewModel = StateObject(wrappedValue: CharacterDetailViewModel(characterId: characterId, characterService: characterService))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                loadingView
            } else if viewModel.errorMessage != nil && viewModel.headerViewModel == nil {
                errorView
            } else if let headerVM = viewModel.headerViewModel,
                      let basicInfoVM = viewModel.basicInfoViewModel,
                      let episodesVM = viewModel.episodesViewModel {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        CharacterHeaderView(viewModel: headerVM)
                        CharacterBasicInfoView(viewModel: basicInfoVM)
                        CharacterEpisodesView(viewModel: episodesVM)
                    }
                    .padding()
                }
                .navigationTitle("Character")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                emptyView
            }
        }
        .onAppear {
            viewModel.loadCharacterDetail()
        }
    }
    

    private var loadingView: some View {
        VStack(spacing: 16) {
            Spacer()
            ProgressView()
            Text("Loading character...")
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private var errorView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.red)
            Text("Error")
                .font(.headline)
            Text(viewModel.errorMessage ?? "Unknown error")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Try Again") {
                viewModel.retry()
            }
            .buttonStyle(.bordered)
            Spacer()
        }
    }

    private var emptyView: some View {
        VStack {
            Spacer()
            Text("Character not found")
                .font(.headline)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        CharacterDetailView(characterId: 1)
    }
}
