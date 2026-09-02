public struct ProfileContent: Equatable, Sendable {
    public let name: String
    public let role: String
    public let photoAccessibilityLabel: String
    public let quote: String

    public init(name: String, role: String, photoAccessibilityLabel: String, quote: String) { self.name = name; self.role = role; self.photoAccessibilityLabel = photoAccessibilityLabel; self.quote = quote }

    public static let developer = ProfileContent(name: ProfileTexts.name, role: ProfileTexts.developer, photoAccessibilityLabel: ProfileTexts.photo, quote: ProfileTexts.quote)
}
