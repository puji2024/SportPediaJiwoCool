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

@MainActor @Observable
final class TeamsViewModel {
    private let getTeams: any GetTeamsUseCase
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    @ObservationIgnored private let searchSubject = CurrentValueSubject<String, Never>("")
    private(set) var teams: [Team] = []
    private(set) var filteredTeams: [Team] = []
    private(set) var state: LoadState = .idle
    var searchText = "" {
        didSet { searchSubject.send(searchText) }
    }
    var sort: TeamSort = .name {
        didSet { applyFilter() }
    }

    init(getTeams: any GetTeamsUseCase) {
        self.getTeams = getTeams
        bindSearch()
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

    private func bindSearch() {
        searchSubject
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in self?.applyFilter() }
            .store(in: &cancellables)
    }

    private func applyFilter() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let searchedTeams = query.isEmpty ? teams : teams.filter {
            $0.name.localizedCaseInsensitiveContains(query)
                || ($0.country?.localizedCaseInsensitiveContains(query) ?? false)
        }
        filteredTeams = sort(teams: searchedTeams)
    }

    private func sort(teams: [Team]) -> [Team] {
        teams.sorted {
            switch sort {
            case .name:
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
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
