import XCTest

final class ProductDetailUITests: XCTestCase {

    func testGoToProductDetail() {
        let app = XCUIApplication()
        app.launch()

        let collectionView = app.collectionViews["home_product_collectionView"]

        let productCell = collectionView.cells["product_cell_0_0"]
        let cellExistsPredicate = NSPredicate(format: "exists == true")
        let cellExistsExpectation = expectation(
            for: cellExistsPredicate,
            evaluatedWith: productCell,
            handler: nil
        )

        let timeout: TimeInterval = 10
        waitForExpectations(timeout: timeout) { error in
            if let error = error {
                XCTFail("Failed to fulfill the expectation: \(error)")
            } else {
                productCell.tap()
                cellExistsExpectation.fulfill()

                let elementsToCheck: [XCUIElement] = [
                    app.staticTexts["title_label"],
                    app.staticTexts["brand_label"],
                    app.images["discount_imageView"],
                    app.staticTexts["discount_label"],
                    app.images["rating_imageView"],
                    app.staticTexts["rating_label"],
                    app.images["stock_imageView"],
                    app.staticTexts["stock_label"],
                    app.staticTexts["description_label"]
                ]

                elementsToCheck.forEach { label in
                    XCTAssertTrue(
                        label.exists,
                        "The \(label.identifier) should be displayed on the product detail screen."
                    )
                }
            }
        }
    }

    func testGoBackAfterGoToProductDetail() {
        let app = XCUIApplication()
        app.launch()

        let collectionView = app.collectionViews["home_product_collectionView"]

        let productCell = collectionView.cells["product_cell_0_0"]
        let cellExistsPredicate = NSPredicate(format: "exists == true")
        let cellExistsExpectation = expectation(
            for: cellExistsPredicate,
            evaluatedWith: productCell,
            handler: nil
        )

        let timeout: TimeInterval = 10
        waitForExpectations(timeout: timeout) { error in
            if let error = error {
                XCTFail("Failed to fulfill the expectation: \(error)")
            } else {
                productCell.tap()
                cellExistsExpectation.fulfill()

                let backButton = app.scrollViews.otherElements.buttons["back_button"]
                backButton.tap()

                XCTAssertTrue(collectionView.exists)
            }
        }
    }
}
