public enum TeamSort: String, CaseIterable, Identifiable, Sendable {
    case name
    case country

    public var id: String { rawValue }
}
