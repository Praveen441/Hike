import SwiftUI

struct CharacterListView: View {
    @StateObject var viewModel: CharacterListViewModel
    @State private var searchText = ""
    @State private var searchDebounceTask: Task<Void, Never>?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(text: $searchText) { text in
                    updateSearch(text)
                }
                .padding(16)

                if viewModel.isLoading && viewModel.characterRowVMs.isEmpty {
                    loadingView
                } else if viewModel.errorMessage != nil && viewModel.characterRowVMs.isEmpty {
                    errorView
                } else if viewModel.characterRowVMs.isEmpty {
                    emptyView
                } else {
                    contentView
                }
            }
            .navigationTitle("Characters")
            .onAppear {
                viewModel.loadInitialCharacters()
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            Spacer()
            ProgressView()
            Text("Loading characters...")
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
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.gray)
            Text("No Characters Found")
                .font(.headline)
            Spacer()
        }
    }

    private var contentView: some View {
        List {
            ForEach(Array(viewModel.characterRowVMs.enumerated()), id: \.element.characterDTO.id) { index, rowVM in
                NavigationLink(destination: CharacterDetailView(characterId: rowVM.characterDTO.id)) {
                    CharacterRowView(viewModel: rowVM)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .onAppear {
                    if index >= viewModel.characterRowVMs.count - 2 {
                        viewModel.loadNextPage()
                    }
                }
            }

            if viewModel.isLoading && viewModel.hasMorePages {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }

    private func updateSearch(_ text: String) {
        searchDebounceTask?.cancel()

        searchDebounceTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            viewModel.filterCharacters(by: text)
        }
    }
}

#Preview {
    CharacterListView(
        viewModel: CharacterListViewModel(
            characterService: CharacterServiceImpl(
                repository: CharacterRepositoryImpl(networkService: NetworkService())
            )
        )
    )
}
