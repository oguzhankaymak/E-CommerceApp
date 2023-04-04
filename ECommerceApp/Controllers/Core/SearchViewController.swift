import UIKit

class SearchViewController: UIViewController {

    var coordinator: SearchCoordinatorProtocol?

    var model: SearchViewModel!

    let myArray = ["All", "Electronics", "Jewelery", "Men's clothing", "Women's clothing"]

    private lazy var collectionView: UICollectionView = {
        let section = CompositionalLayoutSectionHelper.createProductCategoriesSection()
        let layout = UICollectionViewCompositionalLayout(section: section)

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
    }
}

// MARK: - ConfigureCollectionView
extension SearchViewController {
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            ProductCategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductCategoryCollectionViewCell.identifier
        )

        collectionView.register(
            CollectionSectionHeaderView.self,
            forSupplementaryViewOfKind: CollectionSectionHeaderView.kind,
            withReuseIdentifier: CollectionSectionHeaderView.identifier
        )
    }
}

// MARK: - UICollectionViewDataSource - UICollectionViewDelegate
extension SearchViewController:
    UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myArray.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
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
                    isCurrentCategory: model.activeCategory.value == currentCategory)
            )

            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CollectionSectionHeaderView.identifier,
            for: indexPath
        ) as? CollectionSectionHeaderView else {
            return UICollectionReusableView()
        }

        supplementaryView.configureModel(with: "Categories")

        return supplementaryView
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
