import Combine
import CoreData
import Domain

public final class FavoriteStore: @unchecked Sendable {
    public static let shared = FavoriteStore()

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    private init() {
        let model = NSManagedObjectModel()
        let entity = NSEntityDescription()
        entity.name = "TeamEntity"
        entity.managedObjectClassName = "NSManagedObject"
        entity.properties = [
            Self.attribute("id", .stringAttributeType, optional: false),
            Self.attribute("name", .stringAttributeType, optional: false),
            Self.attribute("badgeURL", .stringAttributeType),
            Self.attribute("formedYear", .stringAttributeType),
            Self.attribute("stadium", .stringAttributeType),
            Self.attribute("teamDescription", .stringAttributeType),
            Self.attribute("country", .stringAttributeType)
        ]
        model.entities = [entity]

        container = NSPersistentContainer(name: "SportsPedia", managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data gagal dimuat: \(error.localizedDescription)")
            }
        }
        context = container.viewContext
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
    }

    public func favoritesPublisher() -> AnyPublisher<[Team], Error> {
        publisher { try self.all() }
    }

    public func isFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error> {
        publisher { try self.contains(team) }
    }

    public func toggleFavoritePublisher(_ team: Team) -> AnyPublisher<Bool, Error> {
        publisher {
            if try self.contains(team) {
                try self.remove(team)
                return false
            }
            try self.save(team)
            return true
        }
    }

    private func all() throws -> [Team] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TeamEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return try context.fetch(request).compactMap(team(from:))
    }

    private func contains(_ team: Team) throws -> Bool {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TeamEntity")
        request.predicate = NSPredicate(format: "id == %@", team.id)
        request.fetchLimit = 1
        return try context.count(for: request) > 0
    }

    private func save(_ team: Team) throws {
        guard try !contains(team) else { return }
        let object = NSEntityDescription.insertNewObject(forEntityName: "TeamEntity", into: context)
        object.setValue(team.id, forKey: "id")
        object.setValue(team.name, forKey: "name")
        object.setValue(team.badgeURL?.absoluteString, forKey: "badgeURL")
        object.setValue(team.formedYear, forKey: "formedYear")
        object.setValue(team.stadium, forKey: "stadium")
        object.setValue(team.description, forKey: "teamDescription")
        object.setValue(team.country, forKey: "country")
        try context.save()
    }

    private func remove(_ team: Team) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TeamEntity")
        request.predicate = NSPredicate(format: "id == %@", team.id)
        try context.fetch(request).forEach(context.delete)
        try context.save()
    }

    private static func attribute(_ name: String, _ type: NSAttributeType, optional: Bool = true) -> NSAttributeDescription {
        let value = NSAttributeDescription()
        value.name = name
        value.attributeType = type
        value.isOptional = optional
        return value
    }

    private func publisher<Value>(_ operation: @escaping () throws -> Value) -> AnyPublisher<Value, Error> {
        Deferred {
            Future { promise in
                do {
                    promise(.success(try operation()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func team(from object: NSManagedObject) -> Team? {
        guard let id = object.value(forKey: "id") as? String,
              let name = object.value(forKey: "name") as? String else {
            return nil
        }
        return Team(
            id: id,
            name: name,
            badgeURL: (object.value(forKey: "badgeURL") as? String).flatMap(URL.init(string:)),
            formedYear: object.value(forKey: "formedYear") as? String,
            stadium: object.value(forKey: "stadium") as? String,
            description: object.value(forKey: "teamDescription") as? String,
            country: object.value(forKey: "country") as? String
        )
    }
}
