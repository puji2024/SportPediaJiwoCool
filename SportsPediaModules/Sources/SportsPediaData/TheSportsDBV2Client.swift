import Foundation
import SportsPediaCommon
@_exported import SportsPediaDomain

/// Type-safe representation of TheSportsDB v2 REST paths.
public enum SportsDBV2Endpoint: Sendable, Equatable {
    case searchTeam(String)
    case lookupTeam(String)
    case listTeams(leagueID: String)
    case filterTVByDay(String)
    case allCountries
    case allSports
    case allLeagues
    case nextLeagueEvents(String)
    case previousLeagueEvents(String)
    case liveScores(sport: String)
    case allLiveScores

    var pathComponents: [String] {
        switch self {
        case let .searchTeam(query): ["search", "team", query.pathComponent]
        case let .lookupTeam(id): ["lookup", "team", id]
        case let .listTeams(leagueID): ["list", "teams", leagueID]
        case let .filterTVByDay(date): ["filter", "tv", "day", date]
        case .allCountries: ["all", "countries"]
        case .allSports: ["all", "sports"]
        case .allLeagues: ["all", "leagues"]
        case let .nextLeagueEvents(id): ["schedule", "next", "league", id]
        case let .previousLeagueEvents(id): ["schedule", "previous", "league", id]
        case let .liveScores(sport): ["livescore", sport.pathComponent]
        case .allLiveScores: ["livescore", "all"]
        }
    }
}

public struct TheSportsDBV2Client: Sendable {
    private let apiKey: String
    private let client: any HTTPClient
    private let baseURL: URL

    public init(
        apiKey: String,
        client: any HTTPClient = URLSession.shared,
        baseURL: URL = URL(string: "https://www.thesportsdb.com/api/v2/json")!
    ) {
        self.apiKey = apiKey
        self.client = client
        self.baseURL = baseURL
    }

    public func listTeams(inLeague leagueID: String) async throws -> [SportsTeam] {
        let response: TeamResponse = try await fetch(.listTeams(leagueID: leagueID))
        return response.teams.map(SportsTeam.init(dto:))
    }

    public func fetch<Response: Decodable>(_ endpoint: SportsDBV2Endpoint) async throws -> Response {
        var url = baseURL
        endpoint.pathComponents.forEach { url.append(path: $0) }
        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")

        let (data, response) = try await client.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPClientError.invalidResponse
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            throw HTTPClientError.unsuccessfulStatusCode(httpResponse.statusCode)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

private struct TeamResponse: Decodable {
    let teams: [TeamDTO]
}

private struct TeamDTO: Decodable {
    let idTeam: String
    let strTeam: String
    let strBadge: String?
    let intFormedYear: String?
    let strStadium: String?
    let strDescriptionEN: String?
    let strCountry: String?
}

private extension SportsTeam {
    init(dto: TeamDTO) {
        self.init(
            id: dto.idTeam,
            name: dto.strTeam,
            badgeURL: dto.strBadge.flatMap(URL.init(string:)),
            formedYear: dto.intFormedYear,
            stadium: dto.strStadium,
            description: dto.strDescriptionEN,
            country: dto.strCountry
        )
    }
}

private extension String {
    var pathComponent: String {
        lowercased().replacingOccurrences(of: " ", with: "_")
    }
}
