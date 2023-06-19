import XCTest
@testable import ECommerceApp

class ProductDetailViewModelTests: XCTestCase {

    var viewModel: ProductDetailViewModel!
    var mockApiCaller: MockAPICaller!
    var mockProducts: ProductResponse!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = ProductDetailViewModel()
        mockApiCaller = MockAPICaller()
        mockProducts = mockApiCaller.createMockProductResponse()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockApiCaller = nil
        CartHelper.clearCart()
        try super.tearDownWithError()
    }

    func testChangeActiveCarouselImageIndex() {
        let expectedIndex = 2
        viewModel.changeActiveCarouselImageIndex(imageIndex: expectedIndex)

        XCTAssertEqual(
            viewModel.activeCarouselImageIndex.value,
            expectedIndex,
            "Active carousel image index should be expected index: \(expectedIndex)"
        )
    }

    func testAddProductToCart_NewProduct() {
        let product = mockProducts.products[0]
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
        let product = mockProducts.products[0]
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
