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
}

private struct TeamRepositoryStub: TeamRepositoryProtocol {
    let teams: [Team]

    func teamsPublisher() -> AnyPublisher<[Team], Error> { Just(teams).setFailureType(to: Error.self).eraseToAnyPublisher() }
    func favoritesPublisher() -> AnyPublisher<[Team], Error> { Just([]).setFailureType(to: Error.self).eraseToAnyPublisher() }
    func isFavoritePublisher(_: Team) -> AnyPublisher<Bool, Error> { Just(false).setFailureType(to: Error.self).eraseToAnyPublisher() }
    func toggleFavoritePublisher(_: Team) -> AnyPublisher<Bool, Error> { Just(false).setFailureType(to: Error.self).eraseToAnyPublisher() }
}
