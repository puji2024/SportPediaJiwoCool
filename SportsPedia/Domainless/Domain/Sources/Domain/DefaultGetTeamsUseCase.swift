import Combine

public struct DefaultGetTeamsUseCase: GetTeamsUseCase {
    private let repository: any TeamRepositoryProtocol

    public init(repository: any TeamRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() -> AnyPublisher<[Team], Error> {
        repository.teamsPublisher()
    }
}
