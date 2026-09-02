import Combine

public struct DefaultManageFavoriteTeamUseCase: ManageFavoriteTeamUseCase {
    private let repository: any TeamRepositoryProtocol

    public init(repository: any TeamRepositoryProtocol) {
        self.repository = repository
    }

    public func favoritesPublisher() -> AnyPublisher<[Team], Error> {
        repository.favoritesPublisher()
    }

    public func isFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error> {
        repository.isFavoritePublisher(team)
    }

    public func toggleFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error> {
        repository.toggleFavoritePublisher(team)
    }
}
