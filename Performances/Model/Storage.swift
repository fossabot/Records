import CoreData

class Storage {
    let persistentContainer: NSPersistentContainer
    static let sharedInstance = Storage()
    private init() {
        do {
            persistentContainer = try StackBuilder.load(.permanent, inBundle: Bundle(for: Party.self))
        } catch {
            fatalError(message1)
        }
    }
}
