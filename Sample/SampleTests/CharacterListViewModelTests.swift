import XCTest
@testable import Sample

@MainActor
final class CharacterListViewModelTests: XCTestCase {
    private var sut: CharacterListViewModel?
    private var mockNetworkService: MockNetworkService?

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        let repository = CharacterRepositoryImpl(networkService: mockNetworkService ?? MockNetworkService())
        let service = CharacterServiceImpl(repository: repository)
        sut = CharacterListViewModel(characterService: service)
    }

    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testInitialLoad() async {
        guard let sut = sut, let mockNetworkService = mockNetworkService else {
            XCTFail("Setup failed")
            return
        }
        let mockDTO = CharacterDTO(
            id: 1,
            name: "Rick",
            status: "Alive",
            species: "Human",
            gender: "Male",
            origin: LocationDTO(name: "Earth", url: ""),
            location: LocationDTO(name: "Earth", url: ""),
            image: nil,
            episode: []
        )
        let mockResponse = CharacterResponseDTO(
            info: PageInfoDTO(count: 1, pages: 1, next: nil, prev: nil),
            results: [mockDTO]
        )
        mockNetworkService.mockResponse = mockResponse

        sut.loadInitialCharacters()

        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.characterRowVMs.count, 1)
        XCTAssertEqual(sut.characterRowVMs.first?.characterDTO.name, "Rick")
    }

    func testSearchFilter() async {
        guard let sut = sut, let mockNetworkService = mockNetworkService else {
            XCTFail("Setup failed")
            return
        }
        let mockDTOs = [
            CharacterDTO(
                id: 1,
                name: "Rick",
                status: "Alive",
                species: "Human",
                gender: "Male",
                origin: LocationDTO(name: "Earth", url: ""),
                location: LocationDTO(name: "Earth", url: ""),
                image: nil,
                episode: []
            ),
            CharacterDTO(
                id: 2,
                name: "Morty",
                status: "Alive",
                species: "Human",
                gender: "Male",
                origin: LocationDTO(name: "Earth", url: ""),
                location: LocationDTO(name: "Earth", url: ""),
                image: nil,
                episode: []
            )
        ]
        let mockResponse = CharacterResponseDTO(
            info: PageInfoDTO(count: 2, pages: 1, next: nil, prev: nil),
            results: mockDTOs
        )
        mockNetworkService.mockResponse = mockResponse

        sut.loadInitialCharacters()
        try? await Task.sleep(nanoseconds: 100_000_000)

        sut.filterCharacters(by: "Rick")
        try? await Task.sleep(nanoseconds: 600_000_000)

        XCTAssertEqual(sut.characterRowVMs.count, 1)
        XCTAssertEqual(sut.characterRowVMs.first?.characterDTO.name, "Rick")
    }

    func testErrorHandling() async {
        guard let sut = sut, let mockNetworkService = mockNetworkService else {
            XCTFail("Setup failed")
            return
        }
        mockNetworkService.shouldFail = true

        sut.loadInitialCharacters()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.characterRowVMs.isEmpty)
    }
}
