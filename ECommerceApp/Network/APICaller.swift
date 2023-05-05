import Foundation

struct APICaller {
    static let shared = APICaller()

    private init() {}

    public func getProducts(category: String? = nil, completion: @escaping (Result<ProductResponse, Error>) -> Void) {
        var urlStr = "\(Constants.baseAPIURL)/products"

        if let category = category {
            urlStr += "/category/\(category)"
        }

        guard let url = URL(string: urlStr) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }

            do {
                let result = try JSONDecoder().decode(ProductResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    public func getCategories(completion: @escaping (Result<CategoryResponse, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseAPIURL)/products/categories") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }

            do {
                let result = try JSONDecoder().decode([String].self, from: data)
                let categoryResponse = CategoryResponse(categories: result)
                completion(.success(categoryResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    public func searchProducts(text: String, completion: @escaping (Result<ProductResponse, Error>) -> Void) {
        let urlStr = "\(Constants.baseAPIURL)/products/search?q=\(text)"

        guard let url = URL(string: urlStr) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }

            do {
                let result = try JSONDecoder().decode(ProductResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
