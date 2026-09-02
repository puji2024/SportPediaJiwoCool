//
//  TeamRepository.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import Combine
import Foundation

struct TeamRepository: TeamRepositoryProtocol {
    let remote: any TeamRemoteDataSource
    let favorites: any FavoriteDataSource

    func teamsPublisher() -> AnyPublisher<[Team], Error> {
        Deferred {
            Future { promise in
                Task {
                    do { promise(.success(try await remote.fetchTeams())) }
                    catch { promise(.failure(error)) }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    func favoritesPublisher() -> AnyPublisher<[Team], Error> { favorites.favoritesPublisher() }
    func isFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error> { favorites.isFavoritePublisher(team) }
    func toggleFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error> { favorites.toggleFavoritePublisher(team) }
}
