import UIKit

class HomeViewController: UIViewController {

    var coordinator: HomeCoordinatorProtocol?

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
        addUIElements()
        configureCollectionView()
        configureConstraints()
    }
}

// MARK: - configureCollectionView
extension HomeViewController {
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            ProductCategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductCategoryCollectionViewCell.identifier
        )
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

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
                    isCurrentCategory: indexPath.row == 0)
            )
            return cell
        default:
            return UICollectionViewCell()
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
