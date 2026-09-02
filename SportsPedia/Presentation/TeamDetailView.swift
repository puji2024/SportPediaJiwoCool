//
//  TeamDetailView.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import SwiftUI

struct TeamDetailView: View {
    let team: Team
    let favoriteUseCase: any ManageFavoriteTeamUseCase
    @State private var viewModel: TeamDetailViewModel

    init(team: Team, favoriteUseCase: any ManageFavoriteTeamUseCase) {
        self.team = team
        self.favoriteUseCase = favoriteUseCase
        _viewModel = State(initialValue: TeamDetailViewModel(favoriteUseCase: favoriteUseCase))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                HStack {
                    Spacer()
                    AsyncImage(url: team.badgeURL) { image in image.resizable().scaledToFit() } placeholder: { ProgressView() }
                        .frame(width: 180, height: 180)
                        .accessibilityLabel(L10n.Detail.logo(team.name))
                    Spacer()
                }
                Text(team.name).font(.largeTitle.bold())
                HStack(spacing: 10) {
                    DetailBadge(icon: "calendar", text: team.formedYear.map(L10n.Detail.established) ?? L10n.Detail.formedYear)
                    DetailBadge(icon: "building.2", text: team.stadium ?? L10n.Detail.stadium)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.About.team).font(.title2.bold())
                    Text(team.description ?? L10n.Team.descriptionFallback)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle(L10n.Detail.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button { viewModel.toggleFavorite(team) } label: {
                Label(viewModel.isFavorite ? L10n.Detail.Favorite.remove : L10n.Detail.Favorite.save, systemImage: viewModel.isFavorite ? "heart.fill" : "heart")
            }
            .accessibilityIdentifier("favorite-button")
        }
        .task { viewModel.loadFavoriteState(for: team) }
    }
}

private struct DetailBadge: View {
    let icon: String
    let text: String
    var body: some View {
        Label(text, systemImage: icon).font(.subheadline).foregroundStyle(.secondary)
    }
}
