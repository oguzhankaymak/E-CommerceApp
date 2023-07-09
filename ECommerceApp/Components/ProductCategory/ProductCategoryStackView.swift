import UIKit

protocol ProductCategoryStackViewDelegate: AnyObject {
    func productCategoryButtonDidTap(categoryIndex: Int)
}

final class ProductCategoryStackView: UIStackView {

    weak var delegate: ProductCategoryStackViewDelegate?

    // MARK: - Init
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        distribution = .equalSpacing
        spacing = 20
    }

    required init(coder: NSCoder) {
        fatalError("ProductCategoryStackView has not been implemented")
    }

    func showLoading() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }

        for index in 0...3 {
            let skeletonView = ProductCategorySkeletonView()
            skeletonView.accessibilityIdentifier =
            ProductCategorySkeletonView.accessibilityIdentitifier +
            "_\(index)"
            addArrangedSubview(skeletonView)
        }
    }

    func addArrangedCategories(activeCategoryIndex: Int, categories: [String]) {
        arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, category) in categories.enumerated() {
            let isActiveCategory = index == activeCategoryIndex

            let button = ProductCategoryButton()
            button.configure(model: ProductCategoryButtonModel(
                categoryIndex: index,
                categoryName: category,
                isActiveCategory: isActiveCategory)
            )

            button.accessibilityIdentifier =
            ProductCategoryButton.accessibilityIdentifier +
            "_\(index)"

            addArrangedSubview(button)

            button.delegate = self
        }
    }
}

extension ProductCategoryStackView: ProductCategoryButtonDelegate {
    func productCategoryButtonDidTap(categoryIndex: Int) {
        delegate?.productCategoryButtonDidTap(categoryIndex: categoryIndex)
    }
}
