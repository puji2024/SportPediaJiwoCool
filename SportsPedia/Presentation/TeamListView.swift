//
//  TeamListView.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import SwiftUI

struct TeamListView: View {
    let viewModel: TeamsViewModel
    let favoriteUseCase: any ManageFavoriteTeamUseCase

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    LoadingTeamsView()
                case .failed(let message):
                    ContentUnavailableView {
                        Label(L10n.Teams.Unavailable.title, systemImage: "wifi.exclamationmark")
                    } description: {
                        Text(message)
                    } actions: {
                        Button(L10n.Teams.retry) { viewModel.load() }
                            .buttonStyle(.borderedProminent)
                    }
                case .loaded:
                    List(viewModel.filteredTeams) { team in
                        NavigationLink(value: team) { TeamRow(team: team) }
                    }
                    .listStyle(.plain)
                    .refreshable { viewModel.load() }
                }
            }
            .navigationTitle(L10n.Teams.title)
            .searchable(text: $viewModel.searchText, prompt: Text(L10n.Teams.search))
            .toolbar {
                Menu {
                    Picker("Filter", selection: $viewModel.filterField) {
                        Text("Semua").tag(TeamFilterField.all)
                        Text("Nama Tim").tag(TeamFilterField.name)
                        Text("Negara").tag(TeamFilterField.country)
                    }
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                }
                .accessibilityIdentifier("team-filter-menu")
                Menu {
                    Picker(L10n.Teams.sort, selection: $viewModel.sort) {
                        Text(L10n.Teams.Sort.name).tag(TeamSort.name)
                        Text(L10n.Teams.Sort.country).tag(TeamSort.country)
                    }
                } label: {
                    Label(L10n.Teams.sort, systemImage: "arrow.up.arrow.down.circle")
                }
                .accessibilityIdentifier("team-sort-menu")
            }
            .navigationDestination(for: Team.self) { team in TeamDetailView(team: team, favoriteUseCase: favoriteUseCase) }
            .task { viewModel.load() }
        }
    }
}

private struct LoadingTeamsView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView().controlSize(.large)
            Text(L10n.Teams.loading)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
    }
}

struct TeamRow: View {
    let team: Team

    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: team.badgeURL) { image in image.resizable().scaledToFit() } placeholder: { ProgressView() }
                .frame(width: 54, height: 54)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(team.name).font(.headline)
                Text(team.country ?? L10n.Team.countryFallback).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
