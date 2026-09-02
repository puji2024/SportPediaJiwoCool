import Combine
import Domain
import Foundation
import Observation

@MainActor @Observable public final class TeamDetailViewModel {
    private let favoriteUseCase: any ManageFavoriteTeamUseCase
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    public private(set) var isFavorite = false

    public init(favoriteUseCase: any ManageFavoriteTeamUseCase) { self.favoriteUseCase = favoriteUseCase }

    public func loadFavoriteState(for team: Team) {
        favoriteUseCase.isFavoritePublisher(team).receive(on: DispatchQueue.main).replaceError(with: false)
            .sink { [weak self] in self?.isFavorite = $0 }.store(in: &cancellables)
    }

    public func toggleFavorite(_ team: Team) {
        favoriteUseCase.toggleFavoritePublisher(team).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] in self?.isFavorite = $0 }).store(in: &cancellables)
    }
}
