import XCTest
@testable import ECommerceApp

final class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    var mockApiCaller: MockAPICaller!
    var mockProductResponse: ProductResponse!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockApiCaller = MockAPICaller()
        viewModel = HomeViewModel(apiCaller: mockApiCaller)
        mockProductResponse = MockAPICallerHelper.createMockProductResponse()
    }

    override func tearDownWithError() throws {
        mockApiCaller = nil
        viewModel = nil
        mockProductResponse = nil
        CartHelper.clearCart()
        try super.tearDownWithError()
    }

    func testGetProduct_Success() {
        let loadingExpectation = expectation(description: "Loading state expectation.")
        let hotSalesProductsExpectation = expectation(description: "Hot sales products expectation.")
        let recommendProductsExpectation = expectation(description: "Recommend products expectation.")

        viewModel.isLoading.bind { isLoading in
            guard let isLoading = isLoading else {
                return XCTFail("isLoading value was nil.")
            }

            if self.viewModel.hotSalesProducts.value == nil || self.viewModel.recommendProducts.value == nil {
                XCTAssertTrue(isLoading, "isLoading should be true while loading products.")
            } else {
                XCTAssertFalse(isLoading, "isLoading should be false after loaded products.")
                loadingExpectation.fulfill()
            }
        }

        viewModel.hotSalesProducts.bind { [weak self] hotSalesProducts in
            let expectedHotSalesProductsCount = self?.mockProductResponse.products[...10].count
            let hotSalesProductsCount = hotSalesProducts?.count
            let hotSalesProductsCountMessage = """
                Expected hot sales product count: \(String(describing: expectedHotSalesProductsCount)),
                but found: \(hotSalesProductsCount ?? 0)
            """

            XCTAssertEqual(hotSalesProductsCount, expectedHotSalesProductsCount, hotSalesProductsCountMessage)
            hotSalesProductsExpectation.fulfill()
        }

        viewModel.recommendProducts.bind { [weak self] recommendProducts in
            let expectedRecommendProductsCount = self?.mockProductResponse
                .products[11..<self!.mockProductResponse.products.endIndex].count
            let recommendProductsCount = recommendProducts?.count
            let recommendProductsCountMessage = """
                Expected recommend products count: \(String(describing: expectedRecommendProductsCount)),
                but found: \(String(describing: recommendProductsCount))
            """

            XCTAssertEqual(recommendProductsCount, expectedRecommendProductsCount, recommendProductsCountMessage)
            recommendProductsExpectation.fulfill()
        }

        mockApiCaller.productResult = .success(mockProductResponse)
        viewModel.getProducts()

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetProducts_Failure() {
        let loadingExpectation = expectation(description: "Loading state expectation.")
        let hotSalesProductsExpectation = expectation(description: "Hot sales products expectation.")
        let recommendProductsExpectation = expectation(description: "Recommend products expectation.")

        viewModel.isLoading.bind { isLoading in
            guard let isLoading = isLoading else {
                return XCTFail("isLoading value was nil.")
            }

            if self.viewModel.hotSalesProducts.value == nil || self.viewModel.recommendProducts.value == nil {
                XCTAssertTrue(isLoading, "isLoading should be true while loading products.")
            } else {
                XCTAssertFalse(isLoading, "isLoading should be false after loaded products.")
                loadingExpectation.fulfill()
            }
        }

        viewModel.hotSalesProducts.bind { hotSalesProducts in
            let expectedHotSalesProductsCount = 0
            let hotSalesProductsCount = hotSalesProducts?.count
            let hotSalesProductsCountMessage = """
                Expected hot sales product count: \(String(describing: expectedHotSalesProductsCount)),
                but found: \(hotSalesProductsCount ?? 0)
            """

            XCTAssertEqual(hotSalesProductsCount, expectedHotSalesProductsCount, hotSalesProductsCountMessage)
            hotSalesProductsExpectation.fulfill()
        }

        viewModel.recommendProducts.bind { recommendProducts in
            let expectedRecommendProductsCount = 0
            let recommendProductsCount = recommendProducts?.count
            let recommendProductsCountMessage = """
                Expected recommend products count: \(String(describing: expectedRecommendProductsCount)),
                but found: \(String(describing: recommendProductsCount))
            """

            XCTAssertEqual(recommendProductsCount, expectedRecommendProductsCount, recommendProductsCountMessage)
            recommendProductsExpectation.fulfill()
        }

        let error = NSError(domain: "TestError", code: 999, userInfo: nil)
        mockApiCaller.productResult = .failure(error)

        viewModel.getProducts()

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testAddProductToCart_NewProduct() {
        let product = mockProductResponse.products[0]
        viewModel.addProductToCart(product: product)

        XCTAssertEqual(
            AppData.cart.count,
            1,
            "Count of product inside cart should be 1."
        )

        XCTAssertEqual(
            AppData.cart[0].productId,
            product.id,
            "Id of product inside cart should match added product id."
        )
    }

    func testAddProductToCart_ExistingProduct() {
        let product = mockProductResponse.products[0]
        let numberOfProductsToAdd = 3

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
