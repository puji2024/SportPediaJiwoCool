import SwiftUI

public struct ProfileView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Image("DeveloperPhoto", bundle: .main)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 240, height: 240)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.orange, lineWidth: 3))
                    .accessibilityLabel(ProfileContent.developer.photoAccessibilityLabel)

                Text(ProfileContent.developer.name)
                    .font(.title2.bold())

                Text(ProfileContent.developer.role)
                    .foregroundStyle(.secondary)

                Text(ProfileContent.developer.quote)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(ProfileTexts.title)
        }
    }
}
