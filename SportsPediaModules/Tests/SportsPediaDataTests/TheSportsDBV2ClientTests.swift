import Foundation
import Testing
import SportsPediaCommon
@testable import SportsPediaData

@Suite("TheSportsDB v2 client")
struct TheSportsDBV2ClientTests {
    @Test("list teams sends the v2 endpoint and API-key header")
    func listTeamsBuildsV2Request() async throws {
        let response = """
        { "teams": [{ "idTeam": "133604", "strTeam": "Arsenal", "strBadge": null,
        "intFormedYear": "1886", "strStadium": "Emirates Stadium",
        "strDescriptionEN": null, "strCountry": "England" }] }
        """.data(using: .utf8)!
        let spy = HTTPClientSpy(data: response)
        let sut = TheSportsDBV2Client(
            apiKey: "premium-key",
            client: spy,
            baseURL: URL(string: "https://example.com/api/v2/json")!
        )

        let teams = try await sut.listTeams(inLeague: "4328")

        #expect(teams.map { $0.name } == ["Arsenal"])
        #expect(await spy.request?.url?.path == "/api/v2/json/list/teams/4328")
        #expect(await spy.request?.value(forHTTPHeaderField: "X-API-KEY") == "premium-key")
    }
}

private actor HTTPClientSpy: HTTPClient {
    let data: Data
    private(set) var request: URLRequest?

    init(data: Data) { self.data = data }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        self.request = request
        return (data, HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }
}
