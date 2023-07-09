import UIKit

final class ProductCategorySkeletonView: UIView {

    static let accessibilityIdentitifier = "product_category_skeletonView"

    private lazy var containerViewGradientLayer = SkeletonGradientLayer()

    // MARK: - Init
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setGradientLayer()
        configureConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        containerViewGradientLayer.frame = bounds
        containerViewGradientLayer.cornerRadius = Theme.CornerRadius.skeleton
    }

    required init?(coder: NSCoder) {
        fatalError("ProductCategorySkeletonView has not been implemented")
    }

    private func setGradientLayer() {
        layer.addSublayer(containerViewGradientLayer)

        let viewGroup = Animation.makeAnimationGroup()
        viewGroup.beginTime = 0.0
        containerViewGradientLayer.add(viewGroup, forKey: "backgroundColor")
    }

    private func configureConstraints() {
        widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
}
