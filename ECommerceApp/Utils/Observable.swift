import Foundation

class Observable<T> {
    var value: T? {
        didSet {
            _callback?(value)
        }
    }

    private var _callback: ((T?) -> Void)?

    func bind(callback: @escaping (T?) -> Void) {
        _callback = callback
    }
}
