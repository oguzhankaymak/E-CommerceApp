import XCTest

final class HomeUITests: XCTestCase {

    func test_displayProductCell_whenLoadedProducts() {
        let app = XCUIApplication()
        app.launch()

        let collectionView = app.collectionViews["home_product_collectionView"]
        let productCell = collectionView.cells["product_cell_0_0"]
        let productCellExistsPredicate = NSPredicate(format: "exists == true")
        let cellExistsExpectation = expectation(
            for: productCellExistsPredicate,
            evaluatedWith: productCell,
            handler: nil
        )

        let timeout: TimeInterval = 10

        waitForExpectations(timeout: timeout) { error in
            if let error = error {
                XCTFail("Failed to fulfill the expectation: \(error)")
            } else {
                XCTAssertTrue(productCell.exists, "The product cell should be displayed in the home collection view.")

                let elementsToCheck: [XCUIElement] = [
                    productCell.images["productCard_imageView"],
                    productCell.staticTexts["productCard_title_label"],
                    productCell.staticTexts["productCard_description_label"],
                    productCell.images["productCard_rating_imageView"],
                    productCell.staticTexts["productCard_rating_label"],
                    productCell.staticTexts["productCard_price_label"],
                    productCell.buttons["productCard_addToCart_button"]
                ]

                elementsToCheck.forEach { label in
                    XCTAssertTrue(
                        label.exists,
                        "The \(label.identifier) should be displayed in the product cell."
                    )
                }

                cellExistsExpectation.fulfill()
            }
        }
    }

    func test_goToSearchWhenPressExploreButton() {
        let app = XCUIApplication()
        app.launch()

        let collectionView = app.collectionViews["home_product_collectionView"]

        let exploreButton = collectionView.buttons["explore_button"]
        exploreButton.tap()

        let searchField = app.searchFields["Search"]
        XCTAssertTrue(searchField.exists, "The search field should exist after tapping the Explore button.")
    }

    func test_displayCollectionViewHeader() {
        let app = XCUIApplication()
        app.launch()

        let collectionView = app.collectionViews["home_product_collectionView"]

        let imageView = collectionView.images["colletion_header_imageView"]
        let exploreButton = collectionView.buttons["explore_button"]

        XCTAssertTrue(imageView.exists)
        XCTAssertTrue(exploreButton.exists)
    }

    func test_displayCollectionViewSectionHeaders() {
        let app = XCUIApplication()
        app.launch()

        let collectionView = app.collectionViews["home_product_collectionView"]

        let recommendForYouSectionHeader = collectionView.staticTexts["Hot Sales"]
        let hotSalesSectionHeader = collectionView.staticTexts["Recommend For You"]

        XCTAssertTrue(
            recommendForYouSectionHeader.exists,
            "The 'Hot Sales' section header should be displayed in the collection view."
        )
        XCTAssertTrue(
            hotSalesSectionHeader.exists,
            "The 'Recommend For You' section header should be displayed in the collection view."
        )
    }

    func test_cartTabBarBadgeValue_whenAddProductToCart() {
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

                let numberOfProductsToAdd = 2

                firstProductCell.buttons["productCard_addToCart_button"].tap()
                secondProductCell.buttons["productCard_addToCart_button"].tap()

                guard let value = app.buttons["cart_tabBarItem"].value as? String else {
                    XCTFail("badge value not updated")
                    return
                }

                XCTAssertEqual(
                    value,
                    "\(numberOfProductsToAdd) items",
                    "The tab bar badge value should be equal to the count of products added to the cart."
                )
            }
        }
    }
}
