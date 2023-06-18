import XCTest
@testable import ECommerceApp

final class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    var mockAPICaller: MockAPICaller!
    var mockProducts: ProductResponse!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAPICaller = MockAPICaller()
        viewModel = HomeViewModel(apiCaller: mockAPICaller)
        mockProducts = mockAPICaller.createMockProductResponse()
    }

    override func tearDownWithError() throws {
        mockAPICaller = nil
        viewModel = nil
        CartHelper.clearCart()
        try super.tearDownWithError()
    }

    func testGetProductsLoadingState() {
        let expectation = XCTestExpectation(description: "Get products expectation.")

        let successfulResult = Result<ProductResponse, Error>.success(mockProducts)
        mockAPICaller.productResult = successfulResult

        viewModel.getProducts()

        guard let loadingValue = viewModel.isLoading.value else { return XCTFail("Loading value was nil.") }

        XCTAssertTrue(loadingValue, "isLoading should be true while loading products.")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard let loadingValue = self.viewModel.isLoading.value else { return XCTFail("Loading value is nil.") }
            XCTAssertFalse(loadingValue, "isLoading should be false after loaded products.")
            expectation.fulfill()
        }
    }

    func testGetProductsSuccess() {
        let expectation = XCTestExpectation(description: "Get products expectation.")

        let successfulResult = Result<ProductResponse, Error>.success(mockProducts)
        mockAPICaller.productResult = successfulResult

        viewModel.getProducts()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

            XCTAssertEqual(
                self.viewModel.hotSalesProducts.value,
                Array(self.mockProducts.products[...10]),
                "Hot sales products should match expected values."
            )
            XCTAssertEqual(
                self.viewModel.recommendProducts.value,
                Array(self.mockProducts.products[11..<self.mockProducts.products.endIndex]),
                "Recommend products should match expected values."
            )

            expectation.fulfill()
        }
    }

    func testGetProductsFailure() {
        let expectation = XCTestExpectation(description: "Get products expectation.")

        let error = NSError(domain: "TestError", code: 999, userInfo: nil)
        mockAPICaller.productResult = .failure(error)

        viewModel.getProducts()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(
                self.viewModel.hotSalesProducts.value?.count,
                0,
                "Hot sales products count should be 0 on failure."
            )
            XCTAssertEqual(
                self.viewModel.recommendProducts.value?.count,
                0,
                "Recommend products count should be 0 on failure."
            )

            expectation.fulfill()
        }
    }

    func testAddProductToCart_NewProduct() {
        let product = mockProducts.products[0]
        viewModel.addProductToCart(product: product)

        XCTAssertEqual(AppData.cart.count, 1, "Cart should contain 1 product.")
        XCTAssertEqual(
            AppData.cart[0].productId,
            product.id,
            "Product ID in the cart should match the added product's ID."
        )
    }

    func testAddProductToCart_ExistingProduct() {
        let product = mockProducts.products[0]
        let numberOfProductsToAdd = 2

        for _ in 1...numberOfProductsToAdd {
            viewModel.addProductToCart(product: product)
        }

        XCTAssertEqual(AppData.cart.count, 1, "Cart should contain 1 product.")
        XCTAssertEqual(
            AppData.cart[0].productId,
            product.id,
            "Product ID in the cart should match the added product's ID."
        )
        XCTAssertEqual(
            AppData.cart[0].quantity,
            numberOfProductsToAdd,
            """
            Quantity of the product in the cart should be number of added the same products: \(numberOfProductsToAdd)
            """
        )
        XCTAssertEqual(
            AppData.cart[0].totalPrice,
            product.price * Double(numberOfProductsToAdd),
            """
            Total price of the product in the cart should be: \(product.price * Double(numberOfProductsToAdd))
            """
        )
    }
}
