import Foundation

public struct SportsTeam: Codable, Sendable {
    let id: String
    let name: String
    let badgeURL: URL?
    let formedYear: String?
    let stadium: String?
    let description: String?
    let country: String?

    enum CodingKeys: String, CodingKey {
        case id = "idTeam"
        case name = "strTeam"
        case badgeURL = "strBadge"
        case formedYear = "intFormedYear"
        case stadium = "strStadium"
        case description = "strDescriptionEN"
        case country = "strCountry"
    }
}
