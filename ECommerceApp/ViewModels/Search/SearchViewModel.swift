import Foundation

final class SearchViewModel {
    private(set) var activeCategory = Observable<String>()

    init() {
        self.activeCategory.value = "All"
    }

    // MARK: - Public Methods
    func changeActiveCategory(category: String) {
        activeCategory.value = category
    }
}
