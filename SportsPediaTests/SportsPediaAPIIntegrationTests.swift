import Data
import XCTest

final class SportsPediaAPIIntegrationTests: XCTestCase {
    func testFetchesAndDecodesTeamsFromLiveAPI() async throws {
        let teams = try await SportsDBService().fetchTeams()
        let firstTeam = try XCTUnwrap(teams.first, "API harus mengembalikan minimal satu tim.")

        XCTAssertFalse(firstTeam.id.isEmpty, "Tim dari API harus memiliki id.")
        XCTAssertFalse(firstTeam.name.isEmpty, "Tim dari API harus memiliki nama.")
        XCTAssertTrue(teams.contains { $0.country?.isEmpty == false }, "Setidaknya satu tim harus memiliki negara.")
    }
}
