import Combine
import Domain

public struct TeamRepository: TeamRepositoryProtocol {
    private let service: SportsDBService
    private let favorites: FavoriteStore

    public init(service: SportsDBService = SportsDBService(), favorites: FavoriteStore = .shared) {
        self.service = service
        self.favorites = favorites
    }

    public func teamsPublisher() -> AnyPublisher<[Team], Error> {
        service.teamsPublisher()
    }

    public func favoritesPublisher() -> AnyPublisher<[Team], Error> {
        favorites.favoritesPublisher()
    }

    public func isFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error> {
        favorites.isFavoritePublisher(team)
    }

    public func toggleFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error> {
        favorites.toggleFavoritePublisher(team)
    }
}
