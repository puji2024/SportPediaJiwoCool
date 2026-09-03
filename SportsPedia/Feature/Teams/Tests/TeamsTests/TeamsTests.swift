import Combine
import Common
import Domain
import Foundation
import Testing
@testable import Teams

@MainActor
struct TeamsViewModelTests {
    private let teams = [
        Team(id: "ars", name: "Arsenal", badgeURL: nil, formedYear: nil, stadium: nil, description: nil, country: "England"),
        Team(id: "bar", name: "Barcelona", badgeURL: nil, formedYear: nil, stadium: nil, description: nil, country: "Spain"),
        Team(id: "atm", name: "Atletico Madrid", badgeURL: nil, formedYear: nil, stadium: nil, description: nil, country: "Spain")
    ]

    @Test("Filter nama hanya mencocokkan nama tim")
    func filtersByTeamName() {
        let result = TeamsViewModel.filteredTeams(from: teams, searchText: "ars", filterField: .name, sort: .name)
        #expect(result.map(\.name) == ["Arsenal"])
    }

    @Test("Filter negara mencocokkan seluruh tim pada negara yang sama")
    func filtersByCountry() {
        let result = TeamsViewModel.filteredTeams(from: teams, searchText: "spain", filterField: .country, sort: .name)
        #expect(result.map(\.name) == ["Atletico Madrid", "Barcelona"])
    }

    @Test("Filter semua mencari nama dan negara")
    func filtersAcrossFields() {
        let result = TeamsViewModel.filteredTeams(from: teams, searchText: "spain", filterField: .all, sort: .name)
        #expect(result.count == 2)
    }

    @Test("Urutan negara menggunakan nama sebagai tie breaker")
    func sortsByCountryThenName() {
        let result = TeamsViewModel.filteredTeams(from: teams, searchText: "", filterField: .all, sort: .country)
        #expect(result.map(\.name) == ["Arsenal", "Atletico Madrid", "Barcelona"])
    }

    @Test("Memuat daftar tim dan memperbarui state layar")
    func loadsTeams() async {
        let sut = TeamsViewModel(getTeams: GetTeamsUseCaseStub(result: .success(teams)))

        sut.load()
        await Task.yield()

        #expect(sut.state == .loaded)
        #expect(sut.filteredTeams.map(\.name) == ["Arsenal", "Atletico Madrid", "Barcelona"])
    }

    @Test("Kegagalan koneksi menampilkan state gagal")
    func reportsConnectionFailure() async {
        let sut = TeamsViewModel(getTeams: GetTeamsUseCaseStub(result: .failure(URLError(.notConnectedToInternet))))

        sut.load()
        await Task.yield()

        #expect(
            sut.state == .failed(
                CommonLocalization.string(
                    "error.connection",
                    fallback: "Koneksi Terputus. Silakan coba lagi."
                )
            )
        )
    }

    @Test("Detail memuat lalu mengganti status favorit")
    func managesFavoriteStateInDetail() async {
        let sut = TeamDetailViewModel(favoriteUseCase: FavoriteUseCaseStub(isFavorite: false, toggleResult: true))

        sut.loadFavoriteState(for: teams[0])
        await Task.yield()
        #expect(sut.isFavorite == false)

        sut.toggleFavorite(teams[0])
        await Task.yield()
        #expect(sut.isFavorite == true)
    }
}

private struct GetTeamsUseCaseStub: GetTeamsUseCase {
    let result: Result<[Team], URLError>

    func execute() -> AnyPublisher<[Team], Error> {
        switch result {
        case let .success(teams):
            Just(teams).setFailureType(to: Error.self).eraseToAnyPublisher()
        case let .failure(error):
            Fail(error: error).eraseToAnyPublisher()
        }
    }
}

private struct FavoriteUseCaseStub: ManageFavoriteTeamUseCase {
    let isFavorite: Bool
    let toggleResult: Bool

    func favoritesPublisher() -> AnyPublisher<[Team], Error> {
        Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func isFavoritePublisher(_: Team) -> AnyPublisher<Bool, Error> {
        Just(isFavorite).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func toggleFavoritePublisher(_: Team) -> AnyPublisher<Bool, Error> {
        Just(toggleResult).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
