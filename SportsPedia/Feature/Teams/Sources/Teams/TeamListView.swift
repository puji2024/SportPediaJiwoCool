import Domain
import SwiftUI

public struct TeamListView: View {
    public let viewModel: TeamsViewModel
    public let favoriteUseCase: any ManageFavoriteTeamUseCase

    public init(viewModel: TeamsViewModel, favoriteUseCase: any ManageFavoriteTeamUseCase) { self.viewModel = viewModel; self.favoriteUseCase = favoriteUseCase }

    public var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack { Group { switch viewModel.state {
        case .idle, .loading: LoadingTeamsView()
        case .failed(let message): ContentUnavailableView { Label(TeamsTexts.unavailableTitle, systemImage: "wifi.exclamationmark") } description: { Text(message) } actions: { Button(TeamsTexts.retry) { viewModel.load() }.buttonStyle(.borderedProminent) }
        case .loaded: List(viewModel.filteredTeams) { team in NavigationLink(value: team) { TeamRow(team: team) } }.listStyle(.plain).refreshable { viewModel.load() }
        }}.navigationTitle(TeamsTexts.teamsTitle).searchable(text: $viewModel.searchText, prompt: Text(TeamsTexts.search)).toolbar {
            Menu { Picker("Filter", selection: $viewModel.filterField) { Text("Semua").tag(TeamFilterField.all); Text("Nama Tim").tag(TeamFilterField.name); Text("Negara").tag(TeamFilterField.country) } } label: { Label("Filter", systemImage: "line.3.horizontal.decrease.circle") }.accessibilityIdentifier("team-filter-menu")
            Menu { Picker(TeamsTexts.sort, selection: $viewModel.sort) { Text(TeamsTexts.sortName).tag(TeamSort.name); Text(TeamsTexts.sortCountry).tag(TeamSort.country) } } label: { Label(TeamsTexts.sort, systemImage: "arrow.up.arrow.down.circle") }.accessibilityIdentifier("team-sort-menu")
        }.navigationDestination(for: Team.self) { TeamDetailView(team: $0, favoriteUseCase: favoriteUseCase) }.task { viewModel.load() } }
    }
}
