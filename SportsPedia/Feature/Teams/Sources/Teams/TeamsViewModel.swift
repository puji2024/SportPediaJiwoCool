import Combine
import Domain
import Foundation
import Observation

@MainActor @Observable public final class TeamsViewModel {
    private let getTeams: any GetTeamsUseCase
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    public private(set) var teams: [Team] = []
    public private(set) var filteredTeams: [Team] = []
    public private(set) var state: LoadState = .idle
    public var searchText = "" { didSet { applyFilter() } }
    public var sort: TeamSort = .name { didSet { applyFilter() } }
    public var filterField: TeamFilterField = .all { didSet { applyFilter() } }

    public init(getTeams: any GetTeamsUseCase) { self.getTeams = getTeams }

    public func load() {
        state = .loading
        getTeams.execute().receive(on: DispatchQueue.main).sink { [weak self] completion in
            guard case let .failure(error) = completion else { return }
            self?.state = .failed(error is URLError ? TeamsTexts.connectionError : error.localizedDescription)
        } receiveValue: { [weak self] teams in
            self?.teams = teams
            self?.applyFilter()
            self?.state = .loaded
        }.store(in: &cancellables)
    }

    private func applyFilter() {
        filteredTeams = Self.filteredTeams(from: teams, searchText: searchText, filterField: filterField, sort: sort)
    }

    nonisolated static func filteredTeams(from teams: [Team], searchText: String, filterField: TeamFilterField, sort: TeamSort) -> [Team] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let results = query.isEmpty ? teams : teams.filter { team in
            switch filterField {
            case .all: team.name.localizedCaseInsensitiveContains(query) || (team.country?.localizedCaseInsensitiveContains(query) ?? false)
            case .name: team.name.localizedCaseInsensitiveContains(query)
            case .country: team.country?.localizedCaseInsensitiveContains(query) ?? false
            }
        }
        return results.sorted {
            switch sort {
            case .name:
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            case .country:
                let comparison = ($0.country ?? "").localizedCaseInsensitiveCompare($1.country ?? "")
                return comparison == .orderedSame ? $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending : comparison == .orderedAscending
            }
        }
    }
}
