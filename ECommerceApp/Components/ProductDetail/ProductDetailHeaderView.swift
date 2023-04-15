import UIKit

final class ProductDetailHeaderView: UIView {

    lazy var carouselCollectionView: UICollectionView = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging

        let layout = UICollectionViewCompositionalLayout(section: section)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Theme.Color.backgroundColor
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()

    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        let icon = UIImage(
            systemName: "arrow.backward",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        )

        button.setImage(icon?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = Theme.Color.black
        button.backgroundColor = Theme.Color.white
        button.layer.cornerRadius = Theme.CornerRadius.extraSmall
        button.widthAnchor.constraint(equalToConstant: 26).isActive = true
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
        return button
    }()

    lazy var carouselControlStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalCentering
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()

    // MARK: - Init
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addUIElements()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("ProductDetailHeaderView has not been implemented")
    }
}

// MARK: - Configure
extension ProductDetailHeaderView {

    public func configure(productImages: [String]) {
        configureCarouselControlStackView(productImages: productImages)
    }

    private func configureCarouselControlStackView(productImages: [String]) {
        NSLayoutConstraint.activate( [
            carouselControlStackView.widthAnchor.constraint(equalToConstant: CGFloat(productImages.count) * 12)
        ])

        for _ in productImages {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.borderWidth = 1
            view.layer.borderColor = Theme.Color.lightGrey.cgColor
            view.widthAnchor.constraint(equalToConstant: 8).isActive = true
            view.heightAnchor.constraint(equalToConstant: 8).isActive = true
            view.backgroundColor = Theme.Color.lightGrey
            view.layer.cornerRadius = Theme.CornerRadius.extraSmall

            carouselControlStackView.addArrangedSubview(view)
        }
    }
}

// MARK: - Constraints
extension ProductDetailHeaderView {

    private func addUIElements() {
        addSubview(carouselCollectionView)
        addSubview(backButton)
        addSubview(carouselControlStackView)
    }

    private func configureConstraints() {
        let carouselCollectionViewConstraints = [
            carouselCollectionView.topAnchor.constraint(equalTo: topAnchor),
            carouselCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            carouselCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        let backButtonConstraints = [
            backButton.topAnchor.constraint(equalTo: carouselCollectionView.topAnchor, constant: 14),
            backButton.leadingAnchor.constraint(equalTo: carouselCollectionView.leadingAnchor, constant: 14)
        ]

        let carouselControlStackViewConstraints = [
            carouselControlStackView.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: -20),
            carouselControlStackView.centerXAnchor.constraint(equalTo: carouselCollectionView.centerXAnchor)
        ]

        NSLayoutConstraint.activate(carouselCollectionViewConstraints)
        NSLayoutConstraint.activate(backButtonConstraints)
        NSLayoutConstraint.activate(carouselControlStackViewConstraints)
    }
}
