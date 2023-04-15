import Foundation

struct AppData {
    @Storage(key: "cart", defaultValue: [])
    static var cart: [CartProduct]
}
