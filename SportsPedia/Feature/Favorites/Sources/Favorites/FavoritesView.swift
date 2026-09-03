import Domain
import SwiftUI
import Teams

public struct FavoritesView: View {
    public let viewModel: FavoritesViewModel
    public let favoriteUseCase: any ManageFavoriteTeamUseCase

    public init(viewModel: FavoritesViewModel, favoriteUseCase: any ManageFavoriteTeamUseCase) {
        self.viewModel = viewModel
        self.favoriteUseCase = favoriteUseCase
    }

    public var body: some View {
        NavigationStack {
            Group {
                if viewModel.teams.isEmpty {
                    ContentUnavailableView {
                        Label(FavoritesTexts.emptyTitle, systemImage: "heart.slash")
                    } description: {
                        Text(FavoritesTexts.emptyDescription)
                    }
                } else {
                    List {
                        ForEach(viewModel.teams) { team in
                            NavigationLink(value: team) {
                                TeamRow(team: team)
                            }
                        }
                        .onDelete { offsets in
                            offsets
                                .map { viewModel.teams[$0] }
                                .forEach(viewModel.remove)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(FavoritesTexts.title)
            .navigationDestination(for: Team.self) { team in
                TeamDetailView(team: team, favoriteUseCase: favoriteUseCase)
            }
            .onAppear {
                viewModel.refresh()
            }
        }
    }
}
