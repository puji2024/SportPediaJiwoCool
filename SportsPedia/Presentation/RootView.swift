//
//  RootView.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import Common
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
                    Label(
                        CommonLocalization.string("tabs.teams", fallback: "Teams"),
                        systemImage: "sportscourt"
                    )
                }
            Favorites.FavoritesView(viewModel: favoritesViewModel, favoriteUseCase: favoriteUseCase)
                .tabItem {
                    Label(
                        CommonLocalization.string("tabs.favorites", fallback: "Favorites"),
                        systemImage: "heart.fill"
                    )
                }
            Profile.ProfileView()
                .tabItem {
                    Label(
                        CommonLocalization.string("tabs.profile", fallback: "Profile"),
                        systemImage: "person.crop.circle"
                    )
                }
        }
        .tint(.orange)
    }
}
