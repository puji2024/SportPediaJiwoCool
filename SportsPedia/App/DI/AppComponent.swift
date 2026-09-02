import Common
import Data
import Domain

final class AppComponent: BootstrapComponent {
    var rootComponent: RootComponent { RootComponent(parent: self) }
}

final class RootComponent: Component<EmptyDependency> {
    var repository: any TeamRepositoryProtocol {
        shared { TeamRepository() }
    }
}
