import XCTest
@testable import ECommerceApp

final class CartViewModelTests: XCTestCase {

    var viewModel: CartViewModel!
    var mockProducts: [Product]!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = CartViewModel()
        mockProducts = MockAPICallerHelper.createMockProductResponse().products
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockProducts = nil
        CartHelper.clearCart()
        try super.tearDownWithError()
    }

    func testInitialValues() {
        XCTAssertFalse(viewModel.isLoading.value ?? true)
        XCTAssertEqual(viewModel.cartData.value, AppData.cart)
        XCTAssertEqual(viewModel.totalPrice.value, "$0.00")
    }

    func testCheckout() {
        addProductToCart(product: mockProducts[0])
        let checkoutExpectation = expectation(description: "Checkout expectation.")
        let loadingExpectation = expectation(description: "Loading expectation.")

        var expectedIsLoadingValue = true

        viewModel.isLoading.bind { isLoading in
            guard let isLoading = isLoading else {
                return XCTFail("isLoading value was nil.")
            }

            XCTAssertEqual(
                isLoading,
                expectedIsLoadingValue,
                "Expected isLoading value: \(expectedIsLoadingValue) but found: \(isLoading)"
            )

            if expectedIsLoadingValue {
                expectedIsLoadingValue = false
            } else {
                loadingExpectation.fulfill()
            }
        }

        viewModel.onComplete = {
            XCTAssertFalse(self.viewModel.isLoading.value ?? true)
            XCTAssertTrue(AppData.cart.isEmpty)

            checkoutExpectation.fulfill()
        }

        viewModel.checkout()

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testForceClearCart() {
        addProductToCart(product: mockProducts[0])
        viewModel.forceClearCart()
        XCTAssertTrue(AppData.cart.isEmpty)
    }

    private func addProductToCart(product: Product) {
        let cartProduct = CartProduct(
            productId: product.id,
            unitPrice: product.price,
            totalPrice: product.price,
            title: product.title,
            description: product.description,
            brand: product.brand,
            category: product.category,
            thumbnail: product.thumbnail,
            quantity: 1
        )

        viewModel.addProductToCart(cartProduct: cartProduct)
    }
}
