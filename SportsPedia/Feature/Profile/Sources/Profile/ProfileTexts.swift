import Common

enum ProfileTexts {
    private static func value(_ key: String, _ fallback: String) -> String {
        CommonLocalization.string(key, fallback: fallback)
    }
    static let title = value("profile.title", "Profile")
    static let name = value("profile.name", "Puji Wahono")
    static let developer = value("profile.developer", "iOS Developer • Dicoding Capstone")
    static let photo = value("profile.photo", "Foto developer")
    static let quote = value("profile.quote", "Man Jadda wa Jada")
}
