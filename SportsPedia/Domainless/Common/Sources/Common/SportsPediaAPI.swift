import Foundation

public enum SportsPediaAPI {
    public static let sportsDBBaseURL = URL(string: "https://www.thesportsdb.com/api/v1/json/3")!
    public static let premierLeagueID = "4328"

    public static func teamsURL(leagueID: String = premierLeagueID) -> URL {
        var components = URLComponents(
            url: sportsDBBaseURL.appending(path: "lookup_all_teams.php"),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [URLQueryItem(name: "id", value: leagueID)]
        return components.url!
    }
}
