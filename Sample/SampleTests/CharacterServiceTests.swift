import XCTest
@testable import Sample

@MainActor
final class CharacterServiceTests: XCTestCase {
    private var sut: CharacterServiceImpl?
    private var mockNetworkService: MockNetworkService?
    private var repository: CharacterRepositoryImpl?

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        if let mockNetworkService = mockNetworkService {
            repository = CharacterRepositoryImpl(networkService: mockNetworkService)
            if let repository = repository {
                sut = CharacterServiceImpl(repository: repository)
            }
        }
    }

    override func tearDown() {
        sut = nil
        repository = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testFetchCharactersCallsRepository() async throws {
        guard let sut = sut, let mockNetworkService = mockNetworkService else {
            XCTFail("Setup failed")
            return
        }
        let mockDTO = CharacterDTO(
            id: 1, name: "Rick", status: "Alive", species: "Human", gender: "Male",
            origin: LocationDTO(name: "Earth", url: ""),
            location: LocationDTO(name: "Earth", url: ""),
            image: nil, episode: []
        )
        let mockResponse = CharacterResponseDTO(
            info: PageInfoDTO(count: 1, pages: 1, next: nil, prev: nil),
            results: [mockDTO]
        )
        mockNetworkService.mockResponse = mockResponse

        let result = try await sut.fetchCharacters(page: 1, name: nil)

        XCTAssertEqual(result.results.count, 1)
        XCTAssertEqual(result.results.first?.name, "Rick")
    }

    func testFetchCharactersWithSearch() async throws {
        guard let sut = sut, let mockNetworkService = mockNetworkService else {
            XCTFail("Setup failed")
            return
        }
        let mockDTOs = [
            CharacterDTO(
                id: 1, name: "Rick", status: "Alive", species: "Human", gender: "Male",
                origin: LocationDTO(name: "Earth", url: ""),
                location: LocationDTO(name: "Earth", url: ""),
                image: nil, episode: []
            ),
            CharacterDTO(
                id: 2, name: "Morty", status: "Alive", species: "Human", gender: "Male",
                origin: LocationDTO(name: "Earth", url: ""),
                location: LocationDTO(name: "Earth", url: ""),
                image: nil, episode: []
            )
        ]
        let mockResponse = CharacterResponseDTO(
            info: PageInfoDTO(count: 2, pages: 1, next: nil, prev: nil),
            results: mockDTOs
        )
        mockNetworkService.mockResponse = mockResponse

        let result = try await sut.fetchCharacters(page: 1, name: "Rick")

        XCTAssertEqual(result.results.count, 2)
        XCTAssertEqual(result.results.first?.name, "Rick")
    }

    func testFetchCharacterDetail() async throws {
        guard let sut = sut, let mockNetworkService = mockNetworkService else {
            XCTFail("Setup failed")
            return
        }
        let mockCharacterDTO = CharacterDTO(
            id: 1, name: "Rick", status: "Alive", species: "Human", gender: "Male",
            origin: LocationDTO(name: "Earth", url: ""),
            location: LocationDTO(name: "Earth", url: ""),
            image: nil, episode: []
        )
        mockNetworkService.mockCharacterDTO = mockCharacterDTO
        mockNetworkService.mockEpisodeDTOs = []

        let result = try await sut.fetchCharacterDetail(id: 1)

        XCTAssertEqual(result.character.id, 1)
        XCTAssertEqual(result.character.name, "Rick")
        XCTAssertEqual(result.episodes.count, 0)
    }
}
