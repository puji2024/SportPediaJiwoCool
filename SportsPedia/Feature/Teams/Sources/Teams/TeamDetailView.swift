import Domain
import SwiftUI

public struct TeamDetailView: View {
    public let team: Team
    public let favoriteUseCase: any ManageFavoriteTeamUseCase
    @State private var viewModel: TeamDetailViewModel

    public init(team: Team, favoriteUseCase: any ManageFavoriteTeamUseCase) {
        self.team = team
        self.favoriteUseCase = favoriteUseCase
        _viewModel = State(initialValue: TeamDetailViewModel(favoriteUseCase: favoriteUseCase))
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                HStack {
                    Spacer()

                    AsyncImage(url: team.badgeURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 180, height: 180)
                    .accessibilityLabel(TeamsTexts.logo(team.name))

                    Spacer()
                }

                Text(team.name)
                    .font(.largeTitle.bold())

                HStack(spacing: 10) {
                    DetailBadge(
                        icon: "calendar",
                        text: team.formedYear.map(TeamsTexts.established) ?? TeamsTexts.formedYear
                    )
                    DetailBadge(
                        icon: "building.2",
                        text: team.stadium ?? TeamsTexts.stadium
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(TeamsTexts.about)
                        .font(.title2.bold())

                    Text(team.description ?? TeamsTexts.descriptionFallback)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle(TeamsTexts.detailTitle)
#if os(iOS)
        .toolbar(.hidden, for: .tabBar)
#endif
        .toolbar {
            Button {
                viewModel.toggleFavorite(team)
            } label: {
                Label(
                    viewModel.isFavorite ? TeamsTexts.favoriteRemove : TeamsTexts.favoriteSave,
                    systemImage: viewModel.isFavorite ? "heart.fill" : "heart"
                )
            }
            .accessibilityIdentifier("favorite-button")
        }
        .task {
            viewModel.loadFavoriteState(for: team)
        }
    }
}
