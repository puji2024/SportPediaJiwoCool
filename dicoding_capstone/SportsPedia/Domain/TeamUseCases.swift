//
//  TeamUseCases.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import Combine

/// Domain contracts. Presentation knows these use cases, never a remote/local data source.
protocol TeamRepositoryProtocol: Sendable {
    func teamsPublisher() -> AnyPublisher<[Team], Error>
    func favoritesPublisher() -> AnyPublisher<[Team], Error>
    func isFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error>
    func toggleFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error>
}

protocol GetTeamsUseCase: Sendable {
    func execute() -> AnyPublisher<[Team], Error>
}

protocol ManageFavoriteTeamUseCase: Sendable {
    func favoritesPublisher() -> AnyPublisher<[Team], Error>
    func isFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error>
    func toggleFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error>
}

struct DefaultGetTeamsUseCase: GetTeamsUseCase {
    private let repository: any TeamRepositoryProtocol

    init(repository: any TeamRepositoryProtocol) { self.repository = repository }

    func execute() -> AnyPublisher<[Team], Error> { repository.teamsPublisher() }
}

struct DefaultManageFavoriteTeamUseCase: ManageFavoriteTeamUseCase {
    private let repository: any TeamRepositoryProtocol

    init(repository: any TeamRepositoryProtocol) { self.repository = repository }

    func favoritesPublisher() -> AnyPublisher<[Team], Error> { repository.favoritesPublisher() }
    func isFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error> { repository.isFavoritePublisher(team) }
    func toggleFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error> { repository.toggleFavoritePublisher(team) }
}
