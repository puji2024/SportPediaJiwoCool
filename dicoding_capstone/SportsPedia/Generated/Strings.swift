// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum About {
    /// Tentang Tim
    internal static let team = L10n.tr("Localizable", "about.team", fallback: "Tentang Tim")
  }
  internal enum Common {
    /// Tidak tersedia
    internal static let notAvailable = L10n.tr("Localizable", "common.notAvailable", fallback: "Tidak tersedia")
  }
  internal enum Detail {
    /// Est. %@
    internal static func established(_ p1: Any) -> String {
      return L10n.tr("Localizable", "detail.established", String(describing: p1), fallback: "Est. %@")
    }
    /// Tahun tidak tersedia
    internal static let formedYear = L10n.tr("Localizable", "detail.formedYear", fallback: "Tahun tidak tersedia")
    /// Logo %@
    internal static func logo(_ p1: Any) -> String {
      return L10n.tr("Localizable", "detail.logo", String(describing: p1), fallback: "Logo %@")
    }
    /// Stadion tidak tersedia
    internal static let stadium = L10n.tr("Localizable", "detail.stadium", fallback: "Stadion tidak tersedia")
    /// Team Detail
    internal static let title = L10n.tr("Localizable", "detail.title", fallback: "Team Detail")
    internal enum Favorite {
      /// Hapus dari favorit
      internal static let remove = L10n.tr("Localizable", "detail.favorite.remove", fallback: "Hapus dari favorit")
      /// Simpan ke favorit
      internal static let save = L10n.tr("Localizable", "detail.favorite.save", fallback: "Simpan ke favorit")
    }
  }
  internal enum Error {
    /// Koneksi Terputus. Silakan coba lagi.
    internal static let connection = L10n.tr("Localizable", "error.connection", fallback: "Koneksi Terputus. Silakan coba lagi.")
    /// Server tidak dapat memproses permintaan saat ini.
    internal static let server = L10n.tr("Localizable", "error.server", fallback: "Server tidak dapat memproses permintaan saat ini.")
  }
  internal enum Favorites {
    /// Favorites
    internal static let title = L10n.tr("Localizable", "favorites.title", fallback: "Favorites")
    internal enum Empty {
      /// Tekan ikon hati pada detail tim untuk menyimpannya.
      internal static let description = L10n.tr("Localizable", "favorites.empty.description", fallback: "Tekan ikon hati pada detail tim untuk menyimpannya.")
      /// Belum ada tim favorit
      internal static let title = L10n.tr("Localizable", "favorites.empty.title", fallback: "Belum ada tim favorit")
    }
  }
  internal enum Profile {
    /// iOS Developer • Dicoding Capstone
    internal static let developer = L10n.tr("Localizable", "profile.developer", fallback: "iOS Developer • Dicoding Capstone")
    /// Puji Wahono
    internal static let name = L10n.tr("Localizable", "profile.name", fallback: "Puji Wahono")
    /// Foto developer
    internal static let photo = L10n.tr("Localizable", "profile.photo", fallback: "Foto developer")
    /// Man Jadda wa Jada
    internal static let quote = L10n.tr("Localizable", "profile.quote", fallback: "Man Jadda wa Jada")
    /// Profile
    internal static let title = L10n.tr("Localizable", "profile.title", fallback: "Profile")
  }
  internal enum Tabs {
    /// Favorites
    internal static let favorites = L10n.tr("Localizable", "tabs.favorites", fallback: "Favorites")
    /// Profile
    internal static let profile = L10n.tr("Localizable", "tabs.profile", fallback: "Profile")
    /// Teams
    internal static let teams = L10n.tr("Localizable", "tabs.teams", fallback: "Teams")
  }
  internal enum Team {
    /// Football Club
    internal static let countryFallback = L10n.tr("Localizable", "team.countryFallback", fallback: "Football Club")
    /// Deskripsi tim belum tersedia.
    internal static let descriptionFallback = L10n.tr("Localizable", "team.descriptionFallback", fallback: "Deskripsi tim belum tersedia.")
  }
  internal enum Teams {
    /// Memuat tim…
    internal static let loading = L10n.tr("Localizable", "teams.loading", fallback: "Memuat tim…")
    /// Coba Lagi
    internal static let retry = L10n.tr("Localizable", "teams.retry", fallback: "Coba Lagi")
    /// Cari nama atau negara tim
    internal static let search = L10n.tr("Localizable", "teams.search", fallback: "Cari nama atau negara tim")
    /// SportsPedia
    internal static let title = L10n.tr("Localizable", "teams.title", fallback: "SportsPedia")
    internal enum Unavailable {
      /// Tidak dapat memuat daftar tim saat ini.
      internal static let description = L10n.tr("Localizable", "teams.unavailable.description", fallback: "Tidak dapat memuat daftar tim saat ini.")
      /// Tidak dapat memuat tim
      internal static let title = L10n.tr("Localizable", "teams.unavailable.title", fallback: "Tidak dapat memuat tim")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = Bundle.main.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
