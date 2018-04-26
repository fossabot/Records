import Foundation

/// With thanks to: https://stackoverflow.com/a/34375827/9400730
func typeName(_ some: Any) -> String {
  return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
}
