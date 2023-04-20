import UIKit
import OrderedCollections

class HomeViewController: UIViewController {

    var coordinator: HomeCoordinatorProtocol?
    var model: HomeViewModel!

    let sections: OrderedDictionary<String, NSCollectionLayoutSection> = [
        "Hot Sales": CompositionalLayoutSectionHelper.createHotSalesProdutsSection(),
        "Recommend For You": CompositionalLayoutSectionHelper.createRecommendForYouProdutsSection()
    ]

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) in

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
        model = HomeViewModel()
        addUIElements()
        configureCollectionView()
        subscribeToModel()
        configureConstraints()
        model.getProducts(limit: 30)

    }
}

// MARK: - ConfigureCollectionView
extension HomeViewController {
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            ProductCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductCollectionViewCell.identifier
        )

        collectionView.register(
            ProductCollectionSkeletonViewCell.self,
            forCellWithReuseIdentifier: ProductCollectionSkeletonViewCell.identifier
        )

        collectionView.register(
            ProductCollectionReusableHeaderView.self,
            forSupplementaryViewOfKind: ProductCollectionReusableHeaderView.kind,
            withReuseIdentifier: ProductCollectionReusableHeaderView.identifier
        )

        collectionView.register(
            CollectionSectionHeaderView.self,
            forSupplementaryViewOfKind: CollectionSectionHeaderView.kind,
            withReuseIdentifier: CollectionSectionHeaderView.identifier
        )
    }
}

// MARK: - UICollectionViewDataSource - UICollectionViewDelegate
extension HomeViewController:
    UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if model.isLoading.value ?? false {
            return 2
        } else {
            switch section {
            case 0:
                return model.hotSalesProducts.value?.count ?? 0
            case 1:
                return model.recommendProducts.value?.count ?? 0
            default:
                return 0
            }
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        if model.isLoading.value ?? false {

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCollectionSkeletonViewCell.identifier,
                for: indexPath
            ) as? ProductCollectionSkeletonViewCell else {
                return UICollectionViewCell()
            }

            return cell

        } else {

            var currentProduct: Product?

            switch indexPath.section {
            case 0:
                currentProduct = model.hotSalesProducts.value?[indexPath.row]
            case 1:
                currentProduct = model.recommendProducts.value?[indexPath.row]
            default:
                currentProduct = nil
            }

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCollectionViewCell.identifier,
                for: indexPath
            ) as? ProductCollectionViewCell,
                  let product = currentProduct
            else {
                return UICollectionViewCell()
            }

            cell.configureModel(product: product)

            cell.delegate = self
            return cell
        }

    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        switch kind {
        case ProductCollectionReusableHeaderView.kind:
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProductCollectionReusableHeaderView.identifier,
                for: indexPath
            ) as? ProductCollectionReusableHeaderView else {
                return UICollectionReusableView()
            }

            supplementaryView.delegate = self

            return supplementaryView

        case CollectionSectionHeaderView.kind:
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CollectionSectionHeaderView.identifier,
                for: indexPath
            ) as? CollectionSectionHeaderView else {
                return UICollectionReusableView()
            }

            let sectionName = sections.elements[indexPath.section].key

            supplementaryView.configureModel(with: sectionName)

            return supplementaryView

        default:
            return UICollectionReusableView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var currentProduct: Product?

        switch indexPath.section {
        case 0:
            currentProduct = model.hotSalesProducts.value?[indexPath.row]
        case 1:
            currentProduct = model.recommendProducts.value?[indexPath.row]
        default:
            currentProduct = nil
        }

        guard let product = currentProduct else { return }

        coordinator?.goToProductDetail(product: product)
    }
}

extension HomeViewController: ProductCollectionReusableHeaderViewDelegate {
    func exploreButtonDidTap() {
        print("exploreButtonDidTap")
    }
}

extension HomeViewController: ProductCollectionViewCellDelegate {
    func productBuyButtonDidTap(product: Product) {

        model.addProductToCart(product: product)
    }
}

// MARK: - SubscribeToModel
extension HomeViewController {
    private func subscribeToModel() {

        model.isLoading.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - Constraints
extension HomeViewController {
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
