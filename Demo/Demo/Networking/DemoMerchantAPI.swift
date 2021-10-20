import Foundation

/// API Client used to create and process orders on sample merchant server
final class DemoMerchantAPI {

    static let sharedService = DemoMerchantAPI()

    private init() {}

    /// This function replicates a way a merchant may go about creating an order on their server and is not part of the SDK flow.
    /// - Parameters:
    ///   - orderParams: the parameters to create the order with
    ///   - completion: a result object vending either the order or an error
    func createOrder(orderParams: CreateOrderParams, completion: @escaping ((Result<Order, URLResponseError>) -> Void)) {
        guard let url = buildBaseURL(with: "/v2/checkout/orders") else {
            completion(.failure(.invalidURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        let encodedClientID = "\(DemoSettings.clientID):".data(using: .utf8)?.base64EncodedString() ?? ""
        urlRequest.addValue("Basic \(encodedClientID)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        urlRequest.httpBody = try? encoder.encode(orderParams)

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.networkConnectionError))
                return
            }

            if response == nil {
                completion(.failure(.serverError))
                return
            }

            do {
                let order = try JSONDecoder().decode(Order.self, from: data)
                completion(.success(order))
            } catch {
                completion(.failure(.dataParsingError))
            }
        }
        .resume()
    }

    /// This function replicates a way a merchant may go about authorizing/capturing an order on their server and is not part of the SDK flow.
    /// - Parameters:
    ///   - processOrderParams: the parameters to process the order with
    ///   - completion: a result object vending either the order or an error
    func processOrder(processOrderParams: ProcessOrderParams, completion: @escaping ((Result<Order, URLResponseError>) -> Void)) {
        guard let url = buildBaseURL(with: "/v2/checkout/orders/" + processOrderParams.orderId + "/" + processOrderParams.intent) else {
            completion(.failure(.invalidURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        let clientSecret = "EPlHO6SzNhuwYMu02SZDyL1mws7XE4hZFkqqks2YAV-Fn8xHy51WJMtryTP5QKlJPasL2c1v4sdd6LmD"
        let encodedClientID = "\(DemoSettings.clientID):\(clientSecret)".data(using: .utf8)?.base64EncodedString() ?? ""
        urlRequest.addValue("Basic \(encodedClientID)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.networkConnectionError))
                return
            }

            if response == nil {
                completion(.failure(.serverError))
                return
            }

            do {
                let order = try JSONDecoder().decode(Order.self, from: data)
                completion(.success(order))
            } catch {
                completion(.failure(.dataParsingError))
            }
        }
        .resume()
    }

    private func buildBaseURL(with endpoint: String) -> URL? {
        URL(string: DemoSettings.environment.baseURL + endpoint)
    }
}
