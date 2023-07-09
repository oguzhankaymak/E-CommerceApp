import UIKit

class ProductDetailViewController: UIViewController {

    var coordinator: ProductDetailCoordinator?
    var product: Product!

    private var model: ProductDetailViewModel!

    private lazy var containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentStackView: UIView = {
        let stackView = UIView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var productDetailHeaderView = ProductDetailHeaderView()
    private lazy var productDetailBodyView = ProductDetailBodyView()
    private lazy var productDetailFooterView = ProductDetailFooterView()

    private lazy var successView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = Theme.Color.secondaryBlack
        return view
    }()

    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Successfully added"
        label.textColor = Theme.Color.white
        label.font = Theme.AppFont.productInfo
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.backgroundColor
        model = ProductDetailViewModel()

        addUIElements()
        configureCarouselCollectionView()
        configureViews()
        configureConstraints()
        subscribeToModel()
    }

    private func showSuccessView() {
        successView.isHidden = false
    }

    private func hideSuccessView() {
        successView.isHidden = true
    }
}

// MARK: - ProductDetailFooterViewDelegate
extension ProductDetailViewController: ProductDetailFooterViewDelegate {
    func buyButtonDidTap() {
        model.addProductToCart(product: product)
    }
}

// MARK: - ConfigureViews
extension ProductDetailViewController {

    private func configureViews() {
        productDetailHeaderView.configure(productImages: product.images)
        productDetailHeaderView.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        productDetailBodyView.configure(
            title: product.title,
            brandName: product.brand,
            discount: ToString(product.discountPercentage),
            rating: ToString(product.rating),
            stock: ToString(product.stock),
            description: product.description
        )

        productDetailFooterView.configure(formattedPrice: String(format: "$%.02f", product.price))
        productDetailFooterView.delegate = self
    }
}

// MARK: - ConfigureNavigationBar
extension ProductDetailViewController {

    @objc private func goBack() {
        coordinator?.goBack()
    }
}

// MARK: - ConfigureCollectionView
extension ProductDetailViewController {

    private func configureCarouselCollectionView() {
        productDetailHeaderView.carouselCollectionView.dataSource = self
        productDetailHeaderView.carouselCollectionView.delegate = self

        productDetailHeaderView.carouselCollectionView.register(
            CarouselImageViewCell.self,
            forCellWithReuseIdentifier: CarouselImageViewCell.identifier
        )
    }
}

// MARK: - UICollectionViewDataSource - UICollectionViewDelegate
extension ProductDetailViewController:
    UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.images.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CarouselImageViewCell.identifier,
            for: indexPath
        ) as? CarouselImageViewCell else {
            return UICollectionViewCell()
        }

        cell.configureModel(with: product.images[indexPath.row])

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        model.changeActiveCarouselImageIndex(imageIndex: indexPath.row)
    }
}

// MARK: - SubscribeToModel
extension ProductDetailViewController {

    private func subscribeToModel() {
        model.activeCarouselImageIndex.bind { [weak self] activeIndex in
            guard let self = self else { return }

            for (i, view) in self.productDetailHeaderView.carouselControlStackView.arrangedSubviews.enumerated() {
                if i == activeIndex {
                    view.backgroundColor = Theme.Color.white
                } else {
                    view.backgroundColor = Theme.Color.lightGrey
                }
            }
        }

        model.isVisibleSuccessView.bind { [weak self] isVisible in
            if isVisible ?? false {
                self?.showSuccessView()
            } else {
                self?.hideSuccessView()
            }
        }
    }
}

// MARK: - Constraints
extension ProductDetailViewController {

    private func addUIElements() {
        view.addSubview(containerScrollView)
        containerScrollView.addSubview(contentStackView)
        contentStackView.addSubview(productDetailHeaderView)
        contentStackView.addSubview(productDetailBodyView)
        contentStackView.addSubview(productDetailFooterView)

        view.addSubview(successView)
        successView.addSubview(successLabel)
    }

    // swiftlint:disable function_body_length
    private func configureConstraints() {
        let containerScrollViewConstraints = [
            containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]

        let contentStackViewConstraints = [
            contentStackView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: containerScrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor),
            contentStackView.heightAnchor.constraint(greaterThanOrEqualTo: containerScrollView.heightAnchor)
        ]

        let productDetailHeaderViewConstraints = [
            productDetailHeaderView.topAnchor.constraint(equalTo: contentStackView.topAnchor),
            productDetailHeaderView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            productDetailHeaderView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            productDetailHeaderView.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.35)
        ]

        let productDetailBodyViewConstraints = [
            productDetailBodyView.topAnchor.constraint(equalTo: productDetailHeaderView.bottomAnchor),
            productDetailBodyView.leadingAnchor.constraint(
                equalTo: contentStackView.leadingAnchor,
                constant: 20
            ),
            productDetailBodyView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: -20),
            productDetailBodyView.bottomAnchor.constraint(equalTo: productDetailFooterView.topAnchor)
        ]

        let productDetailFooterViewConstraints = [
            productDetailFooterView.leadingAnchor.constraint(
                equalTo: contentStackView.leadingAnchor,
                constant: 20
            ),
            productDetailFooterView.trailingAnchor.constraint(
                equalTo: contentStackView.trailingAnchor,
                constant: -20
            ),
            productDetailFooterView.bottomAnchor.constraint(
                equalTo: contentStackView.bottomAnchor,
                constant: -10
            ),
            productDetailFooterView.heightAnchor.constraint(equalToConstant: 50)
        ]

        let successViewConstraints = [
            successView.heightAnchor.constraint(equalToConstant: 60),
            successView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            successView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            successView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        let successLabelConstraints = [
            successLabel.centerYAnchor.constraint(equalTo: successView.centerYAnchor),
            successLabel.leadingAnchor.constraint(equalTo: successView.leadingAnchor, constant: 20)
        ]

        NSLayoutConstraint.activate(containerScrollViewConstraints)
        NSLayoutConstraint.activate(contentStackViewConstraints)
        NSLayoutConstraint.activate(productDetailHeaderViewConstraints)
        NSLayoutConstraint.activate(productDetailBodyViewConstraints)
        NSLayoutConstraint.activate(productDetailFooterViewConstraints)
        NSLayoutConstraint.activate(successViewConstraints)
        NSLayoutConstraint.activate(successLabelConstraints)
    }
}
