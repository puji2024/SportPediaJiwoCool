//
//  SportsDBService.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import Foundation

protocol TeamRemoteDataSource: Sendable {
    func fetchTeams() async throws -> [Team]
}

struct SportsDBService: TeamRemoteDataSource {
    private let url = AppConfiguration.apiBaseURL
        .appending(path: "search_all_teams.php")
        .appending(queryItems: [URLQueryItem(name: "l", value: "English Premier League")])

    func fetchTeams() async throws -> [Team] {
        var request = URLRequest(url: url)
        request.timeoutInterval = 20
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw SportsDBError.invalidResponse
        }
        let payload = try JSONDecoder().decode(TeamResponse.self, from: data)
        return (payload.teams ?? []).map(Team.init(dto:))
    }
}

enum SportsDBError: LocalizedError {
    case invalidResponse

    var errorDescription: String? { L10n.Error.server }
}

private struct TeamResponse: Decodable {
    let teams: [TeamDTO]?
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

private extension Team {
    init(dto: TeamDTO) {
        id = dto.idTeam
        name = dto.strTeam
        badgeURL = dto.strBadge.flatMap(URL.init(string:))
        formedYear = dto.intFormedYear
        stadium = dto.strStadium
        description = dto.strDescriptionEN
        country = dto.strCountry
    }
}
