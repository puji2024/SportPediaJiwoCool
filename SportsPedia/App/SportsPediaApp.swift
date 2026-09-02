//
//  SportsPediaApp.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import Common
import SwiftUI

@main
struct SportsPediaApp: App {
    private let appComponent: AppComponent

    init() {
        registerProviderFactories()
        appComponent = AppComponent()
    }

    var body: some Scene {
        WindowGroup {
            RootView(repository: appComponent.rootComponent.repository)
        }
    }
}
