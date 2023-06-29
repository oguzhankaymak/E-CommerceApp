import XCTest
@testable import ECommerceApp

// swiftlint:disable type_body_length
final class SearchViewModelTests: XCTestCase {

    var mockApiCaller: MockAPICaller!
    var viewModel: SearchViewModel!
    var mockProductResponse: ProductResponse!
    var mockCategoryResponse: CategoryResponse!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockApiCaller = MockAPICaller()
        viewModel = SearchViewModel(apiCaller: mockApiCaller)
        mockProductResponse = MockAPICallerHelper.createMockProductResponse()
        mockCategoryResponse = MockAPICallerHelper.createMockCategoryResponse()
    }

    override func tearDownWithError() throws {
        mockApiCaller = nil
        viewModel = nil
        mockProductResponse = nil
        CartHelper.clearCart()
        try super.tearDownWithError()
    }

    func testGetProduct_Success() {
        let productLoadingExpectation = expectation(description: "Product loading state expectation.")
        let initialProductDataExpectation = expectation(description: "Initial product data expectation.")
        let productsExpectation = expectation(description: "Products expectation.")

        viewModel.isProductLoading.bind { isProductLoading in
            guard let isProductLoading = isProductLoading else {
                return XCTFail("Product loading value was nil.")
            }

            if self.viewModel.initialProductData.value == nil || self.viewModel.products.value == nil {
                XCTAssertTrue(isProductLoading, "isProductLoading should be true while loading products.")
            } else {
                XCTAssertFalse(isProductLoading, "isProductLoading should be false after loaded products.")
                productLoadingExpectation.fulfill()
            }
        }

        viewModel.initialProductData.bind { [weak self] initialProductData in
            let expectedInitialProductDataCount = self?.mockProductResponse.products.count
            let initialProductDataCount = initialProductData?.count
            let initialProductDataCountMessage = """
                Expected initial product data count: \(String(describing: expectedInitialProductDataCount)),
                but found: \(initialProductDataCount ?? 0)
            """

            XCTAssertEqual(initialProductDataCount, expectedInitialProductDataCount, initialProductDataCountMessage)
            initialProductDataExpectation.fulfill()
        }

        viewModel.products.bind { [weak self] products in
            let expectedProductsCount = self?.mockProductResponse.products.count
            let productsCount = products?.count
            let productsCountMessage = """
                Expected products count: \(String(describing: expectedProductsCount)), but found: \(productsCount ?? 0)
            """

            XCTAssertEqual(productsCount, expectedProductsCount, productsCountMessage)
            productsExpectation.fulfill()
        }

        mockApiCaller.productResult = .success(mockProductResponse)
        viewModel.getProducts()

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetProducts_Failure() {
        let productLoadingExpectation = expectation(description: "Product loading state expectation.")
        let initialProductDataExpectation = expectation(description: "Initial product data expectation.")
        let productsExpectation = expectation(description: "Products expectation.")

        viewModel.isProductLoading.bind { isProductLoading in
            guard let isProductLoading = isProductLoading else {
                return XCTFail("Product loading value was nil.")
            }

            if self.viewModel.initialProductData.value == nil || self.viewModel.products.value == nil {
                XCTAssertTrue(isProductLoading, "isProductLoading should be true while loading products.")
            } else {
                XCTAssertFalse(isProductLoading, "isProductLoading should be false after loaded products.")
                productLoadingExpectation.fulfill()
            }
        }

        viewModel.initialProductData.bind { initialProductData in
            let expectedInitialProductDataCount = 0
            let initialProductDataCount = initialProductData?.count ?? 0
            let initialProductDataCountMessage = """
                Expected initial product data count: \(String(describing: expectedInitialProductDataCount)),
                but found: \(initialProductDataCount)
            """

            XCTAssertEqual(initialProductDataCount, expectedInitialProductDataCount, initialProductDataCountMessage)
            initialProductDataExpectation.fulfill()
        }

        viewModel.products.bind { products in
            let expectedProductsCount = 0
            let productsCount = products?.count ?? 0
            let productsCountMessage = """
                Expected products count: \(expectedProductsCount), but found: \(productsCount)
            """
            XCTAssertEqual(productsCount, expectedProductsCount, productsCountMessage)
            productsExpectation.fulfill()
        }

        let error = NSError(domain: "TestError", code: 999, userInfo: nil)
        mockApiCaller.productResult = .failure(error)

        viewModel.getProducts()

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetCategory_Success() {
        let categoriesLoadingExpectation = expectation(description: "Categories loading expectation.")
        let categoriesExpectation = XCTestExpectation(description: "Categories expectation.")

        viewModel.isCategoryLoading.bind { isCategoryLoading in
            guard let isCategoryLoading = isCategoryLoading else {
                return XCTFail("Category loading value was nil.")
            }

            if self.viewModel.categories.value == nil {
                XCTAssertTrue(isCategoryLoading, "isProductLoading should be true while loading categories.")
            } else {
                XCTAssertFalse(isCategoryLoading, "isCategoryLoading should be false after loaded categories.")
                categoriesLoadingExpectation.fulfill()
            }
        }

        viewModel.categories.bind { [weak self] categories in
            let expectedCategoriesCount = (self?.mockCategoryResponse.categories.count ?? 0) + 1
            let categoriesCount = categories?.count ?? 0

            let categoriesCountMessage = """
                Expected categories count: \(expectedCategoriesCount), but found: \(categoriesCount)
            """

            XCTAssertEqual(categoriesCount, expectedCategoriesCount, categoriesCountMessage)

            categoriesExpectation.fulfill()
        }

        mockApiCaller.categoryResult = .success(mockCategoryResponse)
        viewModel.getCategories()

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetCategory_Failure() {
        let categoriesLoadingExpectation = expectation(description: "Categories loading expectation.")
        let categoriesExpectation = XCTestExpectation(description: "Categories expectation.")

        viewModel.isCategoryLoading.bind { isCategoryLoading in
            guard let isCategoryLoading = isCategoryLoading else {
                return XCTFail("Category loading value was nil.")
            }

            if self.viewModel.categories.value == nil {
                XCTAssertTrue(isCategoryLoading, "isProductLoading should be true while loading categories.")
            } else {
                XCTAssertFalse(isCategoryLoading, "isCategoryLoading should be false after loaded categories.")
                categoriesLoadingExpectation.fulfill()
            }
        }

        viewModel.categories.bind { categories in
            let expectedCategoriesCount = 0
            let categoriesCount = categories?.count ?? 0

            let categoriesCountMessage = """
                Expected categories count: \(expectedCategoriesCount), but found: \(categoriesCount)
            """

            XCTAssertEqual(categoriesCount, expectedCategoriesCount, categoriesCountMessage)

            categoriesExpectation.fulfill()
        }

        let error = NSError(domain: "TestError", code: 999, userInfo: nil)
        mockApiCaller.categoryResult = .failure(error)

        viewModel.getCategories()

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

    func testAddProductToCard_ExistingProduct() {
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

    func testChangeActiveCategoryIndex() {
        let activeCategoryIndexExpectation = expectation(description: "Active category index state expectation.")
        let expectedIndex = 2

        viewModel.activeCategoryIndex.bind { activeCategoryIndex in
            XCTAssertEqual(
                activeCategoryIndex,
                expectedIndex,
                "Active category index should be expected index: \(expectedIndex)"
            )

            activeCategoryIndexExpectation.fulfill()
        }

        viewModel.changeActiveCategory(categoryIndex: expectedIndex)

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSearchProducts_TextLessThanOrThree() {
        let initialProductDataExpectation = expectation(description: "Initial product data expectation.")
        let productsExpectation = expectation(description: "Products expectation.")

        viewModel.initialProductData.bind { [weak self] initialProductData in
            let expectedInitialProductDataCount = self?.mockProductResponse.products.count
            let initialProductDataCount = initialProductData?.count
            let initialProductDataCountMessage = """
                Expected initial product data count: \(String(describing: expectedInitialProductDataCount)),
                but found: \(initialProductDataCount ?? 0)
            """

            XCTAssertEqual(initialProductDataCount, expectedInitialProductDataCount, initialProductDataCountMessage)
            initialProductDataExpectation.fulfill()
        }

        viewModel.products.bind { [weak self] products in
            let expectedProductsCount = self?.mockProductResponse.products.count
            let productsCount = products?.count
            let productsCountMessage = """
                Expected products count: \(String(describing: expectedProductsCount)), but found: \(productsCount ?? 0)
            """

            XCTAssertEqual(productsCount, expectedProductsCount, productsCountMessage)
            productsExpectation.fulfill()
        }

        mockApiCaller.productResult = .success(mockProductResponse)
        viewModel.getProducts()

        let searchText = "hi"
        viewModel.searchProducts(text: searchText)

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSearchProducts_TextGreaterThanThree() {
        let productsExpectation = expectation(description: "Products expectation.")

        let searchText = "iPhone"

        let filteredProducts =  MockAPICallerHelper.filterProducts(
            products: mockProductResponse.products,
            searchText: searchText
        )

        viewModel.products.bind { products in
            let expectedFilteredProductsCount = filteredProducts.count
            let productsCount = products?.count ?? 0
            let productsCountMessage = """
                Expected filtered products count: \(expectedFilteredProductsCount), but found: \(productsCount)
            """
            XCTAssertEqual(productsCount, expectedFilteredProductsCount, productsCountMessage)
            productsExpectation.fulfill()
        }

        mockApiCaller.searchResult = .success(MockAPICallerHelper.createMockProductResponse(with: filteredProducts))
        viewModel.searchProducts(text: searchText)

        waitForExpectations(timeout: 5, handler: nil)
    }
}
