import Combine

public protocol ManageFavoriteTeamUseCase: Sendable {
    func favoritesPublisher() -> AnyPublisher<[Team], Error>
    func isFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error>
    func toggleFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error>
}
