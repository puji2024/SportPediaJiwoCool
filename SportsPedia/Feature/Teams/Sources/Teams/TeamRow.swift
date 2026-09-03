import Domain
import SwiftUI

public struct TeamRow: View {
    public let team: Team

    public init(team: Team) {
        self.team = team
    }

    public var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: team.badgeURL) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 54, height: 54)
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(team.name)
                    .font(.headline)

                Text(team.country ?? TeamsTexts.countryFallback)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
