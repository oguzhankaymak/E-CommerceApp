import Foundation

struct APICaller {
    static let shared = APICaller()

    private init() {}

    public func getProducts(limit: Int?, completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseAPIURL)/products") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }

            do {
                let result = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    public func getProductDetail(with productId: Int, completion: @escaping (Result<Product, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseAPIURL)/products/\(productId)") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }

            do {
                let result = try JSONDecoder().decode(Product.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
