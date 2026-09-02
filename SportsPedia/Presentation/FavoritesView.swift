//
//  FavoritesView.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import SwiftUI

struct FavoritesView: View {
    let viewModel: FavoritesViewModel
    let favoriteUseCase: any ManageFavoriteTeamUseCase

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.teams.isEmpty {
                    ContentUnavailableView {
                        Label(L10n.Favorites.Empty.title, systemImage: "heart.slash")
                    } description: {
                        Text(L10n.Favorites.Empty.description)
                    }
                } else {
                    List {
                        ForEach(viewModel.teams) { team in
                            NavigationLink(value: team) { TeamRow(team: team) }
                        }
                        .onDelete { offsets in
                            offsets.map { viewModel.teams[$0] }.forEach(viewModel.remove)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(L10n.Favorites.title)
            .navigationDestination(for: Team.self) { team in TeamDetailView(team: team, favoriteUseCase: favoriteUseCase) }
            .onAppear { viewModel.refresh() }
        }
    }
}
