import Combine
import Domain
import Foundation
import Observation

@MainActor @Observable public final class FavoritesViewModel {
    private let favoritesUseCase: any ManageFavoriteTeamUseCase
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    public private(set) var teams: [Team] = []

    public init(favoritesUseCase: any ManageFavoriteTeamUseCase) { self.favoritesUseCase = favoritesUseCase }

    public func refresh() {
        favoritesUseCase.favoritesPublisher().receive(on: DispatchQueue.main).replaceError(with: [])
            .sink { [weak self] in self?.teams = $0 }.store(in: &cancellables)
    }

    public func remove(_ team: Team) {
        favoritesUseCase.toggleFavoritePublisher(team).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in self?.refresh() }).store(in: &cancellables)
    }
}
