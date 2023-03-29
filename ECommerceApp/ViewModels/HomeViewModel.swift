import Foundation

final class HomeViewModel {
    private(set) var activeCategory = Observable<String>()

    init() {
        self.activeCategory.value = "All"
    }

    // MARK: - Public Methods

    func changeActiveCategory(category: String) {
        activeCategory.value = category
    }
}
