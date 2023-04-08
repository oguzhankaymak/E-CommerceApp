import UIKit

final class SkeletonGradientLayer: CAGradientLayer {

    override init() {
        super.init()

        startPoint = CGPoint(x: 0, y: 0.5)
        endPoint = CGPoint(x: 1, y: 0.5)
    }

    required init?(coder: NSCoder) {
        fatalError("SkeletonGradientLayer has not been implemented")
    }
}
