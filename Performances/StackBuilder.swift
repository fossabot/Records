import CoreData

public class StackBuilder {
    private static let modelName = "Model"
    public enum Configuration {
        case temporary
        case permanent
    }
    public static func load(_ configuration: Configuration, inBundle bundle: Bundle = .main) throws -> NSPersistentContainer {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [bundle])!
        let persistentContainer = NSPersistentContainer(name: StackBuilder.modelName, managedObjectModel: managedObjectModel)
        persistentContainer.persistentStoreDescriptions = [description(for: configuration)]
        var failure: Error?
        persistentContainer.loadPersistentStores { (value, error) in
            let completion = CompletionResult<NSPersistentStoreDescription>(value: value, error: error)
            if case .failure(let eee) = completion {
                failure = eee
            }
        }
        if failure != nil {
            throw failure!
        }
        return persistentContainer
    }
    private static func description(for configuration: Configuration) -> NSPersistentStoreDescription {
        let desc = NSPersistentStoreDescription(url: storeURL)
        switch configuration {
        case .temporary:
            desc.type = NSInMemoryStoreType
        case .permanent:
            desc.shouldInferMappingModelAutomatically = true
            desc.shouldMigrateStoreAutomatically = true
            desc.type = NSSQLiteStoreType
        }
        return desc
    }
    private static var storeURL: URL {
        let storeDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return storeDirectory.appendingPathComponent(StackBuilder.modelName + ".sqlite")
    }
}
