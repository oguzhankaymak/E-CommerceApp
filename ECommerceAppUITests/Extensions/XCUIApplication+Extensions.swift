import Foundation
import XCTest

extension XCUIApplication {
    func resetCart() {
        launchArguments += ["resetCart"]
    }
}
