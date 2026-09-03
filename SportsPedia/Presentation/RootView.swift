//
//  RootView.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import Domain
import Favorites
import Profile
import SwiftUI
import Teams

struct RootView: View {
    @State private var teamsViewModel: Teams.TeamsViewModel
    @State private var favoritesViewModel: Favorites.FavoritesViewModel
    private let favoriteUseCase: any Domain.ManageFavoriteTeamUseCase

    init(repository: any Domain.TeamRepositoryProtocol) {
        let getTeamsUseCase = Domain.DefaultGetTeamsUseCase(repository: repository)
        let favoriteUseCase = Domain.DefaultManageFavoriteTeamUseCase(repository: repository)
        self.favoriteUseCase = favoriteUseCase
        _teamsViewModel = State(initialValue: Teams.TeamsViewModel(getTeams: getTeamsUseCase))
        _favoritesViewModel = State(initialValue: Favorites.FavoritesViewModel(favoritesUseCase: favoriteUseCase))
    }

    var body: some View {
        TabView {
            Teams.TeamListView(viewModel: teamsViewModel, favoriteUseCase: favoriteUseCase)
                .tabItem {
                    Label(L10n.Tabs.teams, systemImage: "sportscourt")
                }
            Favorites.FavoritesView(viewModel: favoritesViewModel, favoriteUseCase: favoriteUseCase)
                .tabItem {
                    Label(L10n.Tabs.favorites, systemImage: "heart.fill")
                }
            Profile.ProfileView()
                .tabItem {
                    Label(L10n.Tabs.profile, systemImage: "person.crop.circle")
                }
        }
        .tint(.orange)
    }
}
