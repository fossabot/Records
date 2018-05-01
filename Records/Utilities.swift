import Foundation

func typeName(_ some: Any) -> String {
  return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
}
