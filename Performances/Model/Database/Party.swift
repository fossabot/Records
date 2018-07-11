@_exported import CoreData
@_exported import Records

@objc(Party)
public class Party: NSManagedObject, Fetchable {
    
    public enum PartyType: String {
        case school = "School"
        case independent = "Independent"
    }
    
    @NSManaged public var email: String
    @NSManaged public var name: String
    @NSManaged public var phone: String
    @NSManaged private var type: String
    @NSManaged public var performers: Set<Performer>?
    
    public var type_: PartyType {
        get {
            return PartyType(rawValue: type)!
        }
        set {
            type = newValue.rawValue
        }
    }
}

// sourcery:inline:Party.ManagedObject.Query.stencil
public extension Party {
    struct Query {
        public var email: String?
        public var name: String?
        public var phone: String?
        public var performers: Aggregate<Performer>?
        public var type: PartyType?

        public init(email: String? = nil, name: String? = nil, phone: String? = nil, performers: Aggregate<Performer>? = nil, type: PartyType? = nil) {
          self.email = email 
          self.name = name 
          self.phone = phone 
          self.performers = performers 
          self.type = type 
        }
    }
}

extension Party.Query: QueryGenerator {

    public typealias Entity = Party

    public var predicateRepresentation: NSCompoundPredicate? {
      var predicates = [NSPredicate]()
      if let predicate = emailPredicate() {
        predicates.append(predicate)
      }
      if let predicate = namePredicate() {
        predicates.append(predicate)
      }
      if let predicate = phonePredicate() {
        predicates.append(predicate)
      }
      if let predicate = performersPredicate() {
        predicates.append(predicate)
      }
      if let predicate = typePredicate() {
        predicates.append(predicate)
      }
      if predicates.count == 0 {
        return nil
      }
      return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

    private func emailPredicate() -> NSPredicate? {
      guard let email = email else { return nil }
      return NSPredicate(format: "email BEGINSWITH[cd] %@", email)
    }
    private func namePredicate() -> NSPredicate? {
      guard let name = name else { return nil }
      return NSPredicate(format: "name BEGINSWITH[cd] %@", name)
    }
    private func phonePredicate() -> NSPredicate? {
      guard let phone = phone else { return nil }
      return NSPredicate(format: "phone BEGINSWITH[cd] %@", phone)
    }
    private func performersPredicate() -> NSPredicate? {
      guard let performers = performers else { return nil }
      return performers.predicate("performers")
    }
    private func typePredicate() -> NSPredicate? {
      guard let type = type else { return nil }
      return NSPredicate(format: "type == %@", type.rawValue as CVarArg)
    }
}
// sourcery:end
