import Foundation

final class ProductDetailViewModel {
    private(set) var activeCarouselImageIndex = Observable<Int>()

    init() {
        self.activeCarouselImageIndex.value = 0
    }

    // MARK: - Public Methods
    func changeActiveCarouselImageIndex(imageIndex: Int) {
        activeCarouselImageIndex.value = imageIndex
    }
}
