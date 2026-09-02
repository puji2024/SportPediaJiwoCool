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
        guard !query.isEmpty else {
            filteredTeams = teams
            return
        }
        filteredTeams = teams.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            ($0.country?.localizedCaseInsensitiveContains(query) ?? false)
        }
    }
}
