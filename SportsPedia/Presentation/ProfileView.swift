//
//  ProfileView.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Image(asset: Asset.developerPhoto)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 240, height: 240)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.orange, lineWidth: 3))
                    .accessibilityLabel(L10n.Profile.photo)
                Text(L10n.Profile.name).font(.title2.bold())
                Text(L10n.Profile.developer)
                    .foregroundStyle(.secondary)
                Text(L10n.Profile.quote)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(L10n.Profile.title)
        }
    }
}
