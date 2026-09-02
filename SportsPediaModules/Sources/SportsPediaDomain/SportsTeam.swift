import Foundation

public struct SportsTeam: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let badgeURL: URL?
    public let formedYear: String?
    public let stadium: String?
    public let description: String?
    public let country: String?

    public init(
        id: String,
        name: String,
        badgeURL: URL?,
        formedYear: String?,
        stadium: String?,
        description: String?,
        country: String?
    ) {
        self.id = id
        self.name = name
        self.badgeURL = badgeURL
        self.formedYear = formedYear
        self.stadium = stadium
        self.description = description
        self.country = country
    }
}
