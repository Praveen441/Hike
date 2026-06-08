import XCTest
@testable import Sample

final class NetworkServiceTests: XCTestCase {
    private var sut: NetworkService?

    override func setUp() {
        super.setUp()
        sut = NetworkService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testExecuteWithValidRequest() async throws {
        let endpoint = RMEndpoint.fetchRMCharacter(id: 1)
        let urlRequest = try endpoint.asURLRequest()

        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertNotNil(urlRequest.url)
    }

    func testEndpointURLConstruction() async throws {
        let endpoint = RMEndpoint.fetchCharacters(page: 2)
        let urlRequest = try endpoint.asURLRequest()

        guard let url = urlRequest.url?.absoluteString else {
            XCTFail("URL should not be nil")
            return
        }

        XCTAssertTrue(url.contains("character"))
        XCTAssertTrue(url.contains("page=2"))
    }

    func testFetchCharacterEndpoint() async throws {
        let endpoint = RMEndpoint.fetchRMCharacter(id: 5)
        let urlRequest = try endpoint.asURLRequest()

        guard let url = urlRequest.url?.absoluteString else {
            XCTFail("URL should not be nil")
            return
        }

        XCTAssertTrue(url.contains("character/5"))
    }
}
