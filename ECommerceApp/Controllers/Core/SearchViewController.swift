import UIKit

class SearchViewController: UIViewController {

    var coordinator: SearchCoordinatorProtocol?
    var model: SearchViewModel!

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal

        let toolbar = UIToolbar(
            frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        )

        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )

        toolbar.items = [UIBarButtonItem.flexibleSpace(), doneButton]
        searchBar.inputAccessoryView = toolbar
        return searchBar
    }()

    private lazy var categoryScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var categoryStackView = ProductCategoryStackView()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(
            section: CompositionalLayoutSectionHelper.createSearchProductSection()
        )

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Theme.Color.backgroundColor
        return collectionView
    }()

    private lazy var emptyDataIconView = EmptyDataIconView(
        frame: CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.backgroundColor
        model = SearchViewModel()
        addUIElements()
        configureCollectionView()
        configureConstraints()
        subscribeToModel()
        model.getCategories()
        model.getProducts()
        categoryStackView.delegate = self
        searchBar.delegate = self
    }

    private func scrollViewScrollToSpecificIndex(categoryIndex: Int) {
        let selectedCategoryView = self.categoryStackView.arrangedSubviews[categoryIndex]
        let selectedCategoryViewFrame = selectedCategoryView.convert(
            selectedCategoryView.bounds,
            to: self.categoryScrollView
        )

        let newContentOffset = CGPoint(
            x: selectedCategoryViewFrame.origin.x - 10,
            y: 0
        )

        self.categoryScrollView.setContentOffset(newContentOffset, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.searchProducts(text: searchText)
    }

    @objc func doneButtonTapped() {
        searchBar.resignFirstResponder()
    }
}

// MARK: - ConfigureCollectionView
extension SearchViewController {
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            ProductCollectionSkeletonViewCell.self,
            forCellWithReuseIdentifier: ProductCollectionSkeletonViewCell.identifier
        )

        collectionView.register(
            ProductCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductCollectionViewCell.identifier
        )
    }
}

// MARK: - UICollectionViewDataSource - UICollectionViewDelegate
extension SearchViewController:
    UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if model.isProductLoading.value ?? true {
            return 4
        } else {
            return model.products.value?.count ?? 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        if model.isProductLoading.value ?? true {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCollectionSkeletonViewCell.identifier,
                for: indexPath
            ) as? ProductCollectionSkeletonViewCell else {
                return UICollectionViewCell()
            }

            return cell

        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCollectionViewCell.identifier,
                for: indexPath
            ) as? ProductCollectionViewCell,
                  let currentProduct = model.products.value?[indexPath.row]
            else {
                return UICollectionViewCell()
            }

            cell.configureModel(product: currentProduct)

            cell.delegate = self
            return cell
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentProduct = model.products.value?[indexPath.row] else { return }
        coordinator?.goToProductDetail(product: currentProduct)
    }
}

// MARK: - ProductCollectionViewCellDelegate
extension SearchViewController: ProductCollectionViewCellDelegate {
    func productBuyButtonDidTap(product: Product) {
        model.addProductToCart(product: product)
    }
}

// MARK: - ProductCategoryStackViewDelegate
extension SearchViewController: ProductCategoryStackViewDelegate {
    func productCategoryButtonDidTap(categoryIndex: Int) {
        model.changeActiveCategory(categoryIndex: categoryIndex)
    }
}

// MARK: - EmptyDataIconView
extension SearchViewController {
    private func showEmptyDataIconView() {
        if collectionView.backgroundView == nil {
            emptyDataIconView.configure(
                model: EmptyDataIconViewModel(
                    title: "Product not found",
                    imageKey: "shippingbox.fill"
                )
            )

            collectionView.backgroundView = emptyDataIconView
        }
    }

    private func hideEmptyDataIconView() {
        if collectionView.backgroundView != nil {
            collectionView.backgroundView = nil
        }
    }
}

// MARK: - SubscribeToModel
extension SearchViewController {
    func subscribeToModel() {
        model.categories.bind { [weak self] categories in
            guard let categories = categories,
                  let activeCategoryIndex = self?.model.activeCategoryIndex.value else {
                return
            }

            self?.categoryStackView.addArrangedCategories(
                activeCategoryIndex: activeCategoryIndex,
                categories: categories
            )
        }

        model.products.bind { [weak self] products in
            guard let products = products else {
                self?.showEmptyDataIconView()
                return
            }

            if products.isEmpty {
                self?.showEmptyDataIconView()
            } else {
                self?.hideEmptyDataIconView()
            }
        }

        model.isProductLoading.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }

        model.isCategoryLoading.bind { [weak self] isLoading in
            if isLoading ?? true {
                self?.categoryStackView.showLoading()
            }
        }

        model.activeCategoryIndex.bind { [weak self] activeCategoryIndex in
            guard let activeCategoryIndex = activeCategoryIndex, let stackView = self?.categoryStackView else { return }

            for subView in stackView.arrangedSubviews {
                if let button = subView as? UIButton {
                    let isActiveCategory = activeCategoryIndex == button.tag
                    button.backgroundColor = isActiveCategory ? Theme.Color.black : Theme.Color.white
                    button.setTitleColor(isActiveCategory ? Theme.Color.white : Theme.Color.black, for: .normal)
                }
            }

            self?.scrollViewScrollToSpecificIndex(categoryIndex: activeCategoryIndex)
        }
    }
}

// MARK: - Constraints
extension SearchViewController {
    private func addUIElements() {
        view.addSubview(searchBar)
        view.addSubview(categoryScrollView)
        categoryScrollView.addSubview(categoryStackView)
        view.addSubview(collectionView)
    }

    private func configureConstraints() {
        let scrollViewHeight = CGFloat(40)

        let searchBarConstraints = [
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ]

        let categoryScrollViewConstraints = [
            categoryScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            categoryScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoryScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            categoryScrollView.heightAnchor.constraint(equalToConstant: scrollViewHeight)
        ]

        let categoryStackViewConstraints = [
            categoryStackView.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryStackView.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor, constant: 8),
            categoryStackView.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor, constant: -8),
            categoryStackView.heightAnchor.constraint(equalToConstant: scrollViewHeight - 10)
        ]

        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]

        NSLayoutConstraint.activate(searchBarConstraints)
        NSLayoutConstraint.activate(categoryScrollViewConstraints)
        NSLayoutConstraint.activate(categoryStackViewConstraints)
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
}
