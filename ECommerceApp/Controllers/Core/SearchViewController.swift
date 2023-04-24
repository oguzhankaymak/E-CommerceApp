import UIKit
import OrderedCollections

class SearchViewController: UIViewController {

    var coordinator: SearchCoordinatorProtocol?

    var model: SearchViewModel!

    let myArray = ["All", "Electronics", "Jewelery", "Men's clothing", "Women's clothing"]

    let sections: OrderedDictionary<String, NSCollectionLayoutSection> = [
        "Category": CompositionalLayoutSectionHelper.createProductCategoriesSection(),
        "Product": CompositionalLayoutSectionHelper.createSearchProductSection()
    ]

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _ ) in

            switch sectionIndex {
            case 0, 1:
                return self.sections.elements[sectionIndex].value
            default:
                return nil
            }
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Theme.Color.backgroundColor
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.backgroundColor
        model = SearchViewModel()
        addUIElements()
        configureCollectionView()
        configureConstraints()
        subscribeToModel()
        model.getProducts(limit: 30)
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
            ProductCategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductCategoryCollectionViewCell.identifier
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

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if model.isLoading.value ?? true {
            return 4
        } else {
            switch section {
            case 0:
                return myArray.count
            case 1:
                return model.products.value?.count ?? 0
            default:
                return 0
            }
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        if model.isLoading.value ?? true && indexPath.section == 1 {

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCollectionSkeletonViewCell.identifier,
                for: indexPath
            ) as? ProductCollectionSkeletonViewCell else {
                return UICollectionViewCell()
            }

            return cell

        } else {
            switch indexPath.section {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProductCategoryCollectionViewCell.identifier,
                    for: indexPath
                ) as? ProductCategoryCollectionViewCell else {
                    return UICollectionViewCell()
                }

                let currentCategory = myArray[indexPath.row]

                cell.configureModel(
                    with: ProductCategoryCellViewModel(
                        title: currentCategory,
                        isCurrentCategory: model.activeCategory.value == currentCategory
                    )
                )

                cell.delegate = self
                return cell

            case 1:
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
            default:
                return UICollectionViewCell()
            }
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

// MARK: - ProductCategoryCollectionViewCellDelegate
extension SearchViewController: ProductCategoryCollectionViewCellDelegate {
    func productCategoryButtonDidTap(category: String) {
        model.changeActiveCategory(category: category)
    }
}

// MARK: - SubscribeToModel
extension SearchViewController {
    func subscribeToModel() {

        model.activeCategory.bind { [weak self]  _ in
            self?.collectionView.reloadData()
        }

        model.isLoading.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - Constraints
extension SearchViewController {

    private func addUIElements() {
        view.addSubview(collectionView)
    }

    private func configureConstraints() {

        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]

        NSLayoutConstraint.activate(collectionViewConstraints)
    }
}
