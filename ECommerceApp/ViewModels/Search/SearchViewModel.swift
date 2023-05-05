import Foundation

final class SearchViewModel {

    private(set) var isProductLoading = Observable<Bool>()
    private(set) var products = Observable<[Product]>()
    private(set) var initialProductData = Observable<[Product]>()
    private(set) var isCategoryLoading = Observable<Bool>()
    private(set) var activeCategoryIndex = Observable<Int>()
    private(set) var categories = Observable<[String]>()

    init() {
        self.activeCategoryIndex.value = 0
    }
}

// MARK: - Public Methods
extension SearchViewModel {
    func getProducts() {
        self.isProductLoading.value = true
        APICaller.shared.getProducts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let productResponse):
                    self?.initialProductData.value = productResponse.products
                    self?.products.value = productResponse.products
                    self?.isProductLoading.value = false

                case .failure(let error):
                    print(error.localizedDescription)
                    self?.isProductLoading.value = false
                }
            }
        }
    }

    func getCategories() {
        self.isCategoryLoading.value = true
        APICaller.shared.getCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categoryResponse):
                    var tmpCategories = Array(categoryResponse.categories)
                    tmpCategories.insert("All", at: 0)
                    self?.categories.value = tmpCategories
                    self?.isCategoryLoading.value = false

                case .failure(let error):
                    print(error.localizedDescription)
                    self?.isCategoryLoading.value = false
                }
            }
        }
    }

    func searchProducts(text: String) {
        if text.count > 3 {
            setInitialCategory()
            getProductsByText(text: text)
        } else {
            setInitialCategory()
            setInitialProducts()
        }
    }

    func changeActiveCategory(categoryIndex: Int) {
        activeCategoryIndex.value = categoryIndex

        if categoryIndex == 0 {
            getProducts()
        } else {
            guard let categories = categories.value else { return }
            getProductsOfCategory(category: categories[categoryIndex])
        }
    }

    func addProductToCart(product: Product) {
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

        CartHelper.addProductToCart(cartProduct: cartProduct)
    }
}

// Private methods
extension SearchViewModel {
    private func getProductsOfCategory(category: String) {
        self.isProductLoading.value = true
        APICaller.shared.getProducts(category: category) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let productResponse):
                    self?.products.value = productResponse.products
                    self?.isProductLoading.value = false

                case .failure(let error):
                    print(error.localizedDescription)
                    self?.isProductLoading.value = false
                }
            }
        }
    }

    private func getProductsByText(text: String) {
        self.isProductLoading.value = true
        APICaller.shared.searchProducts(text: text) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let productResponse):
                    self?.products.value = productResponse.products
                    self?.isProductLoading.value = false

                case .failure(let error):
                    print(error.localizedDescription)
                    self?.isProductLoading.value = false
                }
            }
        }
    }

    private func setInitialCategory() {
        if activeCategoryIndex.value != 0 {
            self.activeCategoryIndex.value = 0
        }
    }

    private func setInitialProducts() {
        if products.value != initialProductData.value {
            self.isProductLoading.value = true
            self.products.value = initialProductData.value
            self.isProductLoading.value = false
        }
    }
}
