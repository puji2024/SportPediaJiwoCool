//
//  SportsPediaApp.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import SwiftUI

@main
struct SportsPediaApp: App {
    private let repository = TeamRepository(
        remote: SportsDBService(),
        favorites: FavoriteStore.shared
    )

    var body: some Scene {
        WindowGroup {
            RootView(repository: repository)
        }
    }
}
