//
//  GetTeamsUseCaseTests.swift
//  SportsPediaTests
//
//  Created by Puji Wahono on 01/09/26.
//

import Combine
import XCTest
@testable import SportsPedia

final class GetTeamsUseCaseTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    func testExecutePublishesTeamsFromRepository() {
        let expected = [Team(id: "1", name: "Arsenal", badgeURL: nil, formedYear: nil, stadium: nil, description: nil, country: "England")]
        let sut = DefaultGetTeamsUseCase(repository: TeamRepositoryStub(teams: expected))
        let expectation = expectation(description: "Publishes expected teams")

        sut.execute()
            .sink(receiveCompletion: { _ in }, receiveValue: { teams in
                XCTAssertEqual(teams, expected)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func testExecuteForwardsRepositoryFailure() {
        let sut = DefaultGetTeamsUseCase(repository: FailingTeamRepositoryStub())
        let expectation = expectation(description: "Forwards repository error")

        sut.execute()
            .sink { completion in
                guard case let .failure(error as StubError) = completion else {
                    return XCTFail("Expected StubError")
                }
                XCTAssertEqual(error, .unavailable)
                expectation.fulfill()
            } receiveValue: { _ in
                XCTFail("A failing repository must not publish teams")
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
}

private struct TeamRepositoryStub: TeamRepositoryProtocol {
    let teams: [Team]

    func teamsPublisher() -> AnyPublisher<[Team], Error> { Just(teams).setFailureType(to: Error.self).eraseToAnyPublisher() }
    func favoritesPublisher() -> AnyPublisher<[Team], Error> { Just([]).setFailureType(to: Error.self).eraseToAnyPublisher() }
    func isFavoritePublisher(_: Team) -> AnyPublisher<Bool, Error> { Just(false).setFailureType(to: Error.self).eraseToAnyPublisher() }
    func toggleFavoritePublisher(_: Team) -> AnyPublisher<Bool, Error> { Just(false).setFailureType(to: Error.self).eraseToAnyPublisher() }
}

private struct FailingTeamRepositoryStub: TeamRepositoryProtocol {
    func teamsPublisher() -> AnyPublisher<[Team], Error> {
        Fail(error: StubError.unavailable).eraseToAnyPublisher()
    }

    func favoritesPublisher() -> AnyPublisher<[Team], Error> {
        Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func isFavoritePublisher(_: Team) -> AnyPublisher<Bool, Error> {
        Just(false).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func toggleFavoritePublisher(_: Team) -> AnyPublisher<Bool, Error> {
        Just(false).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

private enum StubError: Error, Equatable {
    case unavailable
}
