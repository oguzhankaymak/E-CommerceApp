import XCTest

// swiftlint:disable type_body_length
final class CartUITests: XCTestCase {

    func testCartScreenDisplayWhenCartIsEmpty() {
        let app = XCUIApplication()
        app.resetCart()
        app.launch()

        let collectionView = app.collectionViews["home_product_collectionView"]
        let firstProductCell = collectionView.cells["product_cell_0_0"]

        let productExistsPredicate = NSPredicate(format: "exists == true")
        let cellExistsExpectation = expectation(
            for: productExistsPredicate,
            evaluatedWith: firstProductCell,
            handler: nil
        )

        let timeout: TimeInterval = 10

        waitForExpectations(timeout: timeout) { error in
            if let error = error {
                XCTFail("Failed to fulfill the expectation: \(error)")
            } else {
                cellExistsExpectation.fulfill()

                app.buttons["cart_tabBarItem"].tap()

                let emptyCartMessageText = app.staticTexts["cart_EmptyDataTitleLabel"]

                XCTAssertTrue(emptyCartMessageText.exists, "Empty cart message should be displayed")
            }
        }
    }

    func testCartScreenDisplayWhenAddingProductToCart() {
        let app = XCUIApplication()
        app.resetCart()
        app.launch()

        let collectionView = app.collectionViews["home_product_collectionView"]
        let firstProductCell = collectionView.cells["product_cell_0_0"]
        let secondProductCell = collectionView.cells["product_cell_0_1"]

        let productExistsPredicate = NSPredicate(format: "exists == true")
        let cellExistsExpectation = expectation(
            for: productExistsPredicate,
            evaluatedWith: firstProductCell,
            handler: nil
        )

        let timeout: TimeInterval = 10

        waitForExpectations(timeout: timeout) { error in
            if let error = error {
                XCTFail("Failed to fulfill the expectation: \(error)")
            } else {
                cellExistsExpectation.fulfill()

                firstProductCell.buttons["productCard_addToCart_button"].tap()
                secondProductCell.buttons["productCard_addToCart_button"].tap()

                app.buttons["cart_tabBarItem"].tap()

                let cartTableView = app.tables["cart_tableView"]

                let cartProductCell = cartTableView.cells["cart_product_cell_0"]
                let secondCartProductCell = cartTableView.cells["cart_product_cell_1"]

                XCTAssertTrue(
                    cartProductCell.exists,
                    "The first product added to the cart should be displayed on the cart screen."
                )
                XCTAssertTrue(
                    secondCartProductCell.exists,
                    "The second product added to the cart should be displayed on the cart screen."
                )
            }
        }
    }

    func testRemoveAllCartProducts() {
        let app = XCUIApplication()
        app.resetCart()
        app.launch()

        let collectionView = app.collectionViews["home_product_collectionView"]
        let firstProductCell = collectionView.cells["product_cell_0_0"]
        let secondProductCell = collectionView.cells["product_cell_0_1"]

        let productExistsPredicate = NSPredicate(format: "exists == true")
        let cellExistsExpectation = expectation(
            for: productExistsPredicate,
            evaluatedWith: firstProductCell,
            handler: nil
        )

        let timeout: TimeInterval = 10

        waitForExpectations(timeout: timeout) { error in
            if let error = error {
                XCTFail("Failed to fulfill the expectation: \(error)")
            } else {
                cellExistsExpectation.fulfill()

                firstProductCell.buttons["productCard_addToCart_button"].tap()
                secondProductCell.buttons["productCard_addToCart_button"].tap()

                app.buttons["cart_tabBarItem"].tap()

                let cartTableView = app.tables["cart_tableView"]
                let cartProductCell = cartTableView.cells["cart_product_cell_0"]

                XCTAssertTrue(
                    cartProductCell.exists,
                    "The first product added to the cart should be displayed on the cart screen."
                )

                app.tabBars["Tab Bar"].buttons["cart_tabBarItem"].tap()
                app.navigationBars["Cart"].buttons["trash_button"].tap()
                app.alerts["Are you sure?"].scrollViews.otherElements.buttons["Okay"].tap()

                Thread.sleep(forTimeInterval: 1)

                let emptyCartMessageText = app.staticTexts["cart_EmptyDataTitleLabel"]

                XCTAssertTrue(
                    emptyCartMessageText.exists,
                    "Empty cart message should be displayed after removing all products."
                )
            }
        }
    }

    func testRemoveCartProductDelete_swipeLeft() {
        let app = XCUIApplication()
        app.resetCart()
        app.launch()

        let collectionView = app.collectionViews["home_product_collectionView"]
        let firstProductCell = collectionView.cells["product_cell_0_0"]
        let secondProductCell = collectionView.cells["product_cell_0_1"]

        let productExistsPredicate = NSPredicate(format: "exists == true")

        let cellExistsExpectation = expectation(
            for: productExistsPredicate,
            evaluatedWith: firstProductCell,
            handler: nil
        )

        let timeout: TimeInterval = 10

        waitForExpectations(timeout: timeout) { error in
            if let error = error {
                XCTFail("Failed to fulfill the expectation: \(error)")
            } else {
                cellExistsExpectation.fulfill()

                firstProductCell.buttons["productCard_addToCart_button"].tap()
                secondProductCell.buttons["productCard_addToCart_button"].tap()

                app.buttons["cart_tabBarItem"].tap()

                let cartTableviewTable = app.tables["cart_tableView"]
                let cartProductCell = cartTableviewTable.cells["cart_product_cell_1"]

                XCTAssertTrue(cartProductCell.exists)

                cartProductCell.swipeLeft()
                cartProductCell.coordinate(withNormalizedOffset: CGVector(dx: 0.95, dy: 0.5)).tap()

                XCTAssertFalse(cartProductCell.exists)
            }
        }
    }

    func testRemoveCartProductBySwipeLeft() {
        let app = XCUIApplication()
        app.resetCart()
        app.launch()

        let collectionView = app.collectionViews["home_product_collectionView"]
        let firstProductCell = collectionView.cells["product_cell_0_0"]
        let secondProductCell = collectionView.cells["product_cell_0_1"]

        let productExistsPredicate = NSPredicate(format: "exists == true")
        let cellExistsExpectation = expectation(
            for: productExistsPredicate,
            evaluatedWith: firstProductCell,
            handler: nil
        )

        let timeout: TimeInterval = 10

        waitForExpectations(timeout: timeout) { error in
            if let error = error {
                XCTFail("Failed to fulfill the expectation: \(error)")
            } else {
                cellExistsExpectation.fulfill()

                firstProductCell.buttons["productCard_addToCart_button"].tap()
                secondProductCell.buttons["productCard_addToCart_button"].tap()

                app.buttons["cart_tabBarItem"].tap()

                let cartTableView = app.tables["cart_tableView"]
                let cartProductCell = cartTableView.cells["cart_product_cell_1"]

                XCTAssertTrue(
                    cartProductCell.exists,
                    "The second product added to the cart should be displayed on the cart screen."
                )

                cartProductCell.swipeLeft()
                cartProductCell.coordinate(withNormalizedOffset: CGVector(dx: 0.95, dy: 0.5)).tap()

                XCTAssertFalse(
                    cartProductCell.exists,
                    """
                    The second product should be removed from the cart
                    after swiping left and tapping the delete button.
                    """
                )
            }
        }
    }

    func testRemoveCartProductByPressingMinusButton() {
        let app = XCUIApplication()
        app.resetCart()
        app.launch()

        let collectionView = app.collectionViews["home_product_collectionView"]
        let firstProductCell = collectionView.cells["product_cell_0_0"]
        let secondProductCell = collectionView.cells["product_cell_0_1"]

        let productExistsPredicate = NSPredicate(format: "exists == true")
        let cellExistsExpectation = expectation(
            for: productExistsPredicate,
            evaluatedWith: firstProductCell,
            handler: nil
        )

        let timeout: TimeInterval = 10

        waitForExpectations(timeout: timeout) { error in
            if let error = error {
                XCTFail("Failed to fulfill the expectation: \(error)")
            } else {
                cellExistsExpectation.fulfill()

                firstProductCell.buttons["productCard_addToCart_button"].tap()
                secondProductCell.buttons["productCard_addToCart_button"].tap()

                app.buttons["cart_tabBarItem"].tap()

                let cartTableView = app.tables["cart_tableView"]
                let cartProductCell = cartTableView.cells["cart_product_cell_1"]

                XCTAssertTrue(
                    cartProductCell.exists,
                    "The second product added to the cart should be displayed on the cart screen."
                )

                cartProductCell.buttons["minus_button"].tap()

                XCTAssertFalse(
                    cartProductCell.exists,
                    "The second product should be removed from the cart after pressing the minus button."
                )
            }
        }
    }

    // swiftlint:disable function_body_length
    func testCompleteOrder() {
        let app = XCUIApplication()
        app.resetCart()
        app.launch()

        let collectionView = app.collectionViews["home_product_collectionView"]
        let firstProductCell = collectionView.cells["product_cell_0_0"]
        let secondProductCell = collectionView.cells["product_cell_0_1"]

        let productExistsPredicate = NSPredicate(format: "exists == true")
        let cellExistsExpectation = expectation(
            for: productExistsPredicate,
            evaluatedWith: firstProductCell,
            handler: nil
        )

        let timeout: TimeInterval = 10

        waitForExpectations(timeout: timeout) { error in
            if let error = error {
                XCTFail("Failed to fulfill the expectation: \(error)")
            } else {
                cellExistsExpectation.fulfill()

                firstProductCell.buttons["productCard_addToCart_button"].tap()
                secondProductCell.buttons["productCard_addToCart_button"].tap()

                app.buttons["cart_tabBarItem"].tap()
                app.buttons["checkout_button"].tap()

                Thread.sleep(forTimeInterval: 2)

                let successMainButton = app.buttons["main_button"]
                XCTAssertTrue(
                    successMainButton.exists,
                    "The main button should be displayed after tapping the checkout button."
                )
                successMainButton.tap()

                let productCellExistsExpectation = self.expectation(
                    for: productExistsPredicate,
                    evaluatedWith: firstProductCell,
                    handler: nil
                )

                self.waitForExpectations(timeout: timeout) { error in
                    if let error = error {
                        XCTFail("Failed to fulfill the expectation: \(error)")
                    } else {
                        productCellExistsExpectation.fulfill()
                        XCTAssertTrue(
                            firstProductCell.exists,
                            """
                            The first product cell should be displayed on the home screen after returning from checkout.
                            """
                        )
                        XCTAssertTrue(
                            secondProductCell.exists,
                            """
                            The second product cell should be displayed on the home screen
                            after returning from checkout.
                            """
                        )
                    }
                }
            }
        }
    }
}
