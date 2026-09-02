import Combine
import Common
import Domain
import Foundation

public struct SportsDBService: Sendable {
    public init() {}

    public func teamsPublisher() -> AnyPublisher<[Team], Error> {
        let url = SportsPediaAPI.teamsURL()
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Response.self, decoder: JSONDecoder())
            .map { response in response.teams.map(Team.init) }
            .eraseToAnyPublisher()
    }

    public func fetchTeams() async throws -> [Team] {
        let url = SportsPediaAPI.teamsURL()
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(Response.self, from: data).teams.map(Team.init)
    }

    private struct Response: Decodable {
        let teams: [SportsTeam]
    }
}

private extension Team {
    init(_ sportsTeam: SportsTeam) {
        self.init(
            id: sportsTeam.id,
            name: sportsTeam.name,
            badgeURL: sportsTeam.badgeURL,
            formedYear: sportsTeam.formedYear,
            stadium: sportsTeam.stadium,
            description: sportsTeam.description,
            country: sportsTeam.country
        )
    }
}
