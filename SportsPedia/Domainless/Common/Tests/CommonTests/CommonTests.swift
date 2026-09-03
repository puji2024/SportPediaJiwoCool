import Testing
@testable import Common

@Test func missingKeyUsesFallback() {
    #expect(CommonLocalization.string("missing.key", fallback: "Fallback") == "Fallback")
}
