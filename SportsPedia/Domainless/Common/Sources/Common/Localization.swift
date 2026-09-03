import Foundation

/// Shared localization entry point for all feature modules.
public enum CommonLocalization {
    /// Returns a localized value from Common's resource bundle.
    public static func string(
        _ key: String,
        fallback: String,
        table: String = "Localizable"
    ) -> String {
        Bundle.module.localizedString(forKey: key, value: fallback, table: table)
    }

    /// Returns a localized, formatted value from Common's resource bundle.
    public static func formatted(
        _ key: String,
        fallback: String,
        table: String = "Localizable",
        _ arguments: CVarArg...
    ) -> String {
        String(
            format: string(key, fallback: fallback, table: table),
            locale: .current,
            arguments: arguments
        )
    }
}
