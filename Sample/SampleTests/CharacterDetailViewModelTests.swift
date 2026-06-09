import XCTest
@testable import Sample

@MainActor
final class CharacterDetailViewModelTests: XCTestCase {
    private var sut: CharacterDetailViewModel?
    private var mockNetworkService: MockNetworkService?

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        let repository = CharacterRepositoryImpl(networkService: mockNetworkService ?? MockNetworkService())
        let service = CharacterServiceImpl(repository: repository)
        sut = CharacterDetailViewModel(characterId: 1, characterService: service)
    }

    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testLoadCharacterDetail() async {
        guard let sut = sut, let mockNetworkService = mockNetworkService else {
            XCTFail("Setup failed")
            return
        }
        let mockCharacterDTO = CharacterDTO(
            id: 1,
            name: "Rick",
            status: "Alive",
            species: "Human",
            gender: "Male",
            origin: LocationDTO(name: "Earth", url: ""),
            location: LocationDTO(name: "Citadel of Ricks", url: ""),
            image: nil,
            episode: ["https://rickandmortyapi.com/api/episode/1"]
        )
        let mockEpisodeDTO = EpisodeDTO(
            id: 1,
            name: "Pilot",
            airDate: "December 2, 2013",
            episode: "S01E01"
        )
        mockNetworkService.mockCharacterDTO = mockCharacterDTO
        mockNetworkService.mockEpisodeDTOs = [mockEpisodeDTO]

        sut.loadCharacterDetail()

        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.headerViewModel)
        XCTAssertEqual(sut.headerViewModel?.characterDTO.name, "Rick")
        XCTAssertNotNil(sut.basicInfoViewModel)
        XCTAssertNotNil(sut.episodesViewModel)
    }

    func testLoadCharacterDetailError() async {
        guard let sut = sut, let mockNetworkService = mockNetworkService else {
            XCTFail("Setup failed")
            return
        }
        mockNetworkService.shouldFail = true

        sut.loadCharacterDetail()

        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertNil(sut.headerViewModel)
    }

    func testRetryAfterError() async {
        guard let sut = sut, let mockNetworkService = mockNetworkService else {
            XCTFail("Setup failed")
            return
        }
        mockNetworkService.shouldFail = true
        sut.loadCharacterDetail()
        try? await Task.sleep(nanoseconds: 100_000_000)

        mockNetworkService.shouldFail = false
        let mockCharacterDTO = CharacterDTO(
            id: 1,
            name: "Rick",
            status: "Alive",
            species: "Human",
            gender: "Male",
            origin: LocationDTO(name: "Earth", url: ""),
            location: LocationDTO(name: "Citadel", url: ""),
            image: nil,
            episode: []
        )
        mockNetworkService.mockCharacterDTO = mockCharacterDTO
        mockNetworkService.mockEpisodeDTOs = []

        sut.retry()

        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNil(sut.errorMessage)
        XCTAssertNotNil(sut.headerViewModel)
    }
}
