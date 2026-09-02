//
//  RootView.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import SwiftUI

struct RootView: View {
    @State private var teamsViewModel: TeamsViewModel
    @State private var favoritesViewModel: FavoritesViewModel
    private let favoriteUseCase: any ManageFavoriteTeamUseCase

    init(repository: any TeamRepositoryProtocol) {
        let getTeamsUseCase = DefaultGetTeamsUseCase(repository: repository)
        let favoriteUseCase = DefaultManageFavoriteTeamUseCase(repository: repository)
        self.favoriteUseCase = favoriteUseCase
        _teamsViewModel = State(initialValue: TeamsViewModel(getTeams: getTeamsUseCase))
        _favoritesViewModel = State(initialValue: FavoritesViewModel(favoritesUseCase: favoriteUseCase))
    }

    var body: some View {
        TabView {
            TeamListView(viewModel: teamsViewModel, favoriteUseCase: favoriteUseCase)
                .tabItem { Label(L10n.Tabs.teams, systemImage: "sportscourt") }
            FavoritesView(viewModel: favoritesViewModel, favoriteUseCase: favoriteUseCase)
                .tabItem { Label(L10n.Tabs.favorites, systemImage: "heart.fill") }
            ProfileView()
                .tabItem { Label(L10n.Tabs.profile, systemImage: "person.crop.circle") }
        }
        .tint(.orange)
    }
}
