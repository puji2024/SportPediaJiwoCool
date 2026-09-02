public enum TeamFilterField: String, CaseIterable, Identifiable, Sendable {
    case all
    case name
    case country

    public var id: String { rawValue }
}
