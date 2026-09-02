import Combine

public protocol TeamRepositoryProtocol: Sendable {
    func teamsPublisher() -> AnyPublisher<[Team], Error>
    func favoritesPublisher() -> AnyPublisher<[Team], Error>
    func isFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error>
    func toggleFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error>
}
