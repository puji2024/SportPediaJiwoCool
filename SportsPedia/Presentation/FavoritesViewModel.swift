//
//  FavoritesViewModel.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import Combine
import Foundation
import Observation

@MainActor @Observable
final class FavoritesViewModel {
    private let favoritesUseCase: any ManageFavoriteTeamUseCase
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    private(set) var teams: [Team] = []

    init(favoritesUseCase: any ManageFavoriteTeamUseCase) { self.favoritesUseCase = favoritesUseCase }

    func refresh() {
        favoritesUseCase.favoritesPublisher()
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .sink { [weak self] teams in self?.teams = teams }
            .store(in: &cancellables)
    }

    func remove(_ team: Team) {
        favoritesUseCase.toggleFavoritePublisher(team)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in self?.refresh() })
            .store(in: &cancellables)
    }
}
