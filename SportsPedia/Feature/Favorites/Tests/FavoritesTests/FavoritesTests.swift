import Combine
import Domain
import Testing
@testable import Favorites

@MainActor
struct FavoritesViewModelTests {
    @Test("Refresh menampilkan favorit dari use case")
    func refreshesFavorites() async {
        let arsenal = Team(id: "ars", name: "Arsenal", badgeURL: nil, formedYear: nil, stadium: nil, description: nil, country: "England")
        let sut = FavoritesViewModel(favoritesUseCase: FavoriteUseCaseStub(favorites: [arsenal]))

        sut.refresh()
        await Task.yield()

        #expect(sut.teams == [arsenal])
    }

    @Test("Hapus favorit memuat ulang daftar")
    func removesFavoriteAndRefreshes() async {
        let arsenal = Team(id: "ars", name: "Arsenal", badgeURL: nil, formedYear: nil, stadium: nil, description: nil, country: "England")
        let sut = FavoritesViewModel(favoritesUseCase: FavoriteUseCaseStub(favorites: [], toggledTeam: arsenal))

        sut.remove(arsenal)
        await Task.yield()
        await Task.yield()

        #expect(sut.teams.isEmpty)
    }
}

private struct FavoriteUseCaseStub: ManageFavoriteTeamUseCase {
    let favorites: [Team]
    var toggledTeam: Team? = nil

    func favoritesPublisher() -> AnyPublisher<[Team], Error> {
        Just(favorites).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func isFavoritePublisher(_: Team) -> AnyPublisher<Bool, Error> {
        Just(false).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func toggleFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error> {
        Just(team.id != toggledTeam?.id).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
