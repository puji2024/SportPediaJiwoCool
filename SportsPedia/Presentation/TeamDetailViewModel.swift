//
//  TeamDetailViewModel.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import Combine
import Foundation
import Observation

@MainActor @Observable
final class TeamDetailViewModel {
    private let favoriteUseCase: any ManageFavoriteTeamUseCase
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    private(set) var isFavorite = false

    init(favoriteUseCase: any ManageFavoriteTeamUseCase) {
        self.favoriteUseCase = favoriteUseCase
    }

    func loadFavoriteState(for team: Team) {
        favoriteUseCase.isFavoritePublisher(team)
            .receive(on: DispatchQueue.main)
            .replaceError(with: false)
            .sink { [weak self] in self?.isFavorite = $0 }
            .store(in: &cancellables)
    }

    func toggleFavorite(_ team: Team) {
        favoriteUseCase.toggleFavoritePublisher(team)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] in self?.isFavorite = $0 })
            .store(in: &cancellables)
    }
}
