import Foundation

enum FavoritesTexts {
    private static func value(_ key: String, _ fallback: String) -> String { Bundle.main.localizedString(forKey: key, value: fallback, table: "Localizable") }
    static let title = value("favorites.title", "Favorites")
    static let emptyTitle = value("favorites.empty.title", "Belum ada tim favorit")
    static let emptyDescription = value("favorites.empty.description", "Tekan ikon hati pada detail tim untuk menyimpannya.")
}
