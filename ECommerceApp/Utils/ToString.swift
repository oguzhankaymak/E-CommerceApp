import Foundation

func ToString<T>(_ value: T) -> String {
    if let convertible = value as? CustomStringConvertible {
        return convertible.description
    } else {
        return String(describing: value)
    }
}
