import XCTest

final class SearchUITests: XCTestCase {

    func testGoToSearchWhenPressExploreButton() {
        let app = XCUIApplication()
        app.launch()

        let collectionView = app.collectionViews["home_product_collectionView"]

        let exploreButton = collectionView.buttons["explore_button"]
        exploreButton.tap()

        let searchField = app.searchFields["Search"]
        XCTAssertTrue(searchField.exists, "The search field should exist after tapping the Explore button.")
    }

    func testDisplayCategoryLoadingWhileFetchingCategories() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["search_tabBarItem"].tap()

        XCTAssertTrue(
            app.otherElements["product_category_skeletonView_0"].exists,
            "The category loading view should be displayed while fetching categories."
        )
    }

    func testDisplayCategoriesWhenLoadedCategories() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["search_tabBarItem"].tap()

        let categoryQuery = app.scrollViews.otherElements
        let categoryButton = categoryQuery.buttons["product_category_button_0"]

        let categoryExistsPredicate = NSPredicate(format: "exists == true")
        let categoryExistsExpectation = expectation(
            for: categoryExistsPredicate,
            evaluatedWith: categoryButton,
            handler: nil
        )

        let timeout: TimeInterval = 10

        waitForExpectations(timeout: timeout) { error in
            if let error = error {
                XCTFail("Failed to fulfill the expectation: \(error)")
            } else {
                XCTAssertTrue(
                    categoryButton.exists,
                    "The category button should be displayed in the search view."
                )

                categoryExistsExpectation.fulfill()
            }
        }
    }

    func testDisplayProductSkeletonLoadingCellWhileFetchingProducts() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["search_tabBarItem"].tap()

        let collectionView = app.collectionViews["search_collectionView"]
        let productSkeletonCell = collectionView.cells["product_skeleton_cell_0"]

        XCTAssertTrue(
            productSkeletonCell.exists,
            "The skeleton loading cell should be displayed while fetching products."
        )
    }

    func testDisplayProductCellWhenLoadedProducts() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["search_tabBarItem"].tap()

        let collectionView = app.collectionViews["search_collectionView"]

        let productCell = collectionView.cells["product_cell_0"]
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
                XCTAssertTrue(productCell.exists, "The product cell should be displayed in the search collection view.")

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

    func testCartTabBarBadgeValue_whenAddProductToCart() {
        let app = XCUIApplication()
        app.resetCart()
        app.launch()

        let searchTabbaritemButton = app.buttons["search_tabBarItem"]
        searchTabbaritemButton.tap()

        let collectionView = app.collectionViews["search_collectionView"]
        let firstProductCell = collectionView.cells["product_cell_0"]
        let secondProductCell = collectionView.cells["product_cell_1"]

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
