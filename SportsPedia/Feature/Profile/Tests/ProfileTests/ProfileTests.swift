import Testing
@testable import Profile

struct ProfileContentTests {
    @Test("Profil developer menyediakan informasi yang diperlukan layar")
    func providesDeveloperContent() {
        let content = ProfileContent.developer
        #expect(content.name.isEmpty == false)
        #expect(content.role.isEmpty == false)
        #expect(content.photoAccessibilityLabel.isEmpty == false)
        #expect(content.quote.isEmpty == false)
    }
}
