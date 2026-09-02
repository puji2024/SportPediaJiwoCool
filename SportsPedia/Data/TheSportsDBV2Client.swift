import Foundation

protocol HTTPClient: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPClient {}

enum HTTPClientError: LocalizedError {
    case invalidResponse
    case unsuccessfulStatusCode(Int)
}

struct SportsTeam: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let name: String
    let badgeURL: URL?
    let formedYear: String?
    let stadium: String?
    let description: String?
    let country: String?
}

struct TheSportsDBV1Client: Sendable {
    private let client: any HTTPClient
    private let baseURL: URL

    init(client: any HTTPClient = URLSession.shared, baseURL: URL = AppConfiguration.sportsDBBaseURL) {
        self.client = client
        self.baseURL = baseURL
    }

    func listTeams(inLeague leagueID: String) async throws -> [SportsTeam] {
        var components = URLComponents(url: baseURL.appending(path: "lookup_all_teams.php"), resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "id", value: leagueID)]
        guard let url = components?.url else { throw HTTPClientError.invalidResponse }
        let response: TeamResponse = try await fetch(url)
        return response.teams
    }

    private func fetch<Response: Decodable>(_ url: URL) async throws -> Response {
        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        let (data, response) = try await client.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw HTTPClientError.invalidResponse }
        guard 200..<300 ~= httpResponse.statusCode else { throw HTTPClientError.unsuccessfulStatusCode(httpResponse.statusCode) }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

private struct TeamResponse: Decodable { let teams: [SportsTeam] }

private extension SportsTeam {
    enum CodingKeys: String, CodingKey { case id = "idTeam", name = "strTeam", badgeURL = "strBadge", formedYear = "intFormedYear", stadium = "strStadium", description = "strDescriptionEN", country = "strCountry" }
}
