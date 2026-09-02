import Combine

public protocol GetTeamsUseCase: Sendable {
    func execute() -> AnyPublisher<[Team], Error>
}
