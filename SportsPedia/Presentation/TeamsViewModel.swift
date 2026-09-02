//
//  TeamsViewModel.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import Combine
import Foundation
import Observation

enum LoadState: Equatable {
    case idle, loading, loaded, failed(String)
}

enum TeamSort: String, CaseIterable, Identifiable, Sendable {
    case name
    case country

    var id: String { rawValue }
}

enum TeamFilterField: String, CaseIterable, Identifiable, Sendable {
    case all
    case name
    case country

    var id: String { rawValue }
}

@MainActor @Observable
final class TeamsViewModel {
    private let getTeams: any GetTeamsUseCase
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    private(set) var teams: [Team] = []
    private(set) var filteredTeams: [Team] = []
    private(set) var state: LoadState = .idle
    var searchText = "" {
        didSet { applyFilter() }
    }
    var sort: TeamSort = .name {
        didSet { applyFilter() }
    }
    var filterField: TeamFilterField = .all {
        didSet { applyFilter() }
    }

    init(getTeams: any GetTeamsUseCase) {
        self.getTeams = getTeams
    }

    func load() {
        state = .loading
        getTeams.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else { return }
                self?.state = error is URLError
                    ? .failed(L10n.Error.connection)
                    : .failed(error.localizedDescription)
            } receiveValue: { [weak self] teams in
                self?.teams = teams
                self?.applyFilter()
                self?.state = .loaded
            }
            .store(in: &cancellables)
    }

    private func applyFilter() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let searchedTeams = query.isEmpty ? teams : teams.filter { team in
            switch filterField {
            case .all:
                team.name.localizedCaseInsensitiveContains(query)
                    || (team.country?.localizedCaseInsensitiveContains(query) ?? false)
            case .name:
                team.name.localizedCaseInsensitiveContains(query)
            case .country:
                team.country?.localizedCaseInsensitiveContains(query) ?? false
            }
        }
        filteredTeams = sort(teams: searchedTeams)
    }

    private func sort(teams: [Team]) -> [Team] {
        teams.sorted {
            switch sort {
            case .name:
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            case .country:
                let firstCountry = $0.country ?? ""
                let secondCountry = $1.country ?? ""
                if firstCountry.localizedCaseInsensitiveCompare(secondCountry) == .orderedSame {
                    return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                }
                return firstCountry.localizedCaseInsensitiveCompare(secondCountry) == .orderedAscending
            }
        }
    }
}
