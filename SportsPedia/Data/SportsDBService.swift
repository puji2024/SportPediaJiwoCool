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
    private let client: TheSportsDBV1Client
    private let leagueID: String

    init(
        client: TheSportsDBV1Client = TheSportsDBV1Client(),
        leagueID: String = "4328"
    ) {
        self.client = client
        self.leagueID = leagueID
    }

    func fetchTeams() async throws -> [Team] {
        return try await client.listTeams(inLeague: leagueID).map(Team.init(apiTeam:))
    }
}

enum SportsDBError: LocalizedError {
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidResponse: L10n.Error.server
        }
    }
}

private extension Team {
    init(apiTeam: SportsTeam) {
        id = apiTeam.id
        name = apiTeam.name
        badgeURL = apiTeam.badgeURL
        formedYear = apiTeam.formedYear
        stadium = apiTeam.stadium
        description = apiTeam.description
        country = apiTeam.country
    }
}
