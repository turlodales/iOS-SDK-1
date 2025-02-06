import Foundation

public enum NetworkingError {

    static let domain = "NetworkingClientErrorDomain"

    enum Code: Int {
        /// 0. An unknown error occured.
        case unknown

        /// 1. Error returned from URLSession while making request.
        case urlSessionError

        /// 2. An error occured decoding HTTP response data
        case jsonDecodingError

        /// 3. Invalid HTTPURLResponse from network.
        case invalidURLResponse

        /// 4. Missing HTTP response data.
        case noResponseData

        /// 5. There was an error constructing the URLRequest.
        case invalidURLRequest

        /// 6. The server's response body returned an error message.
        case serverResponseError
        
        /// 7. Missing expected GraphQL response data key.
        case noGraphQLDataKey
    }

    public static let unknownError = CoreSDKError(
        code: Code.unknown.rawValue,
        domain: domain,
        errorDescription: "An unknown error occured. Contact developer.paypal.com/support."
    )

    public static let urlSessionError = CoreSDKError(
        code: Code.urlSessionError.rawValue,
        domain: domain,
        errorDescription: "An error occured during network call. Contact developer.paypal.com/support."
    )

    public static let jsonDecodingError: (String) -> CoreSDKError = { description in
        CoreSDKError(
            code: Code.jsonDecodingError.rawValue,
            domain: domain,
            errorDescription: description
        )
    }

    public static let invalidURLResponseError = CoreSDKError(
        code: Code.invalidURLResponse.rawValue,
        domain: domain,
        errorDescription: "An error occured due to an invalid HTTP response. Contact developer.paypal.com/support."
    )

    public static let noResponseDataError = CoreSDKError(
        code: Code.noResponseData.rawValue,
        domain: domain,
        errorDescription: "An error occured due to missing HTTP response data. Contact developer.paypal.com/support."
    )

    public static let invalidURLRequestError = CoreSDKError(
        code: Code.invalidURLRequest.rawValue,
        domain: domain,
        errorDescription: "An error occured constructing an HTTP request. Contact developer.paypal.com/support."
    )

    public static let serverResponseError: (String) -> CoreSDKError = { description in
        CoreSDKError(
            code: Code.serverResponseError.rawValue,
            domain: domain,
            errorDescription: description
        )
    }
    
    public static let noGraphQLDataKey = CoreSDKError(
        code: Code.noGraphQLDataKey.rawValue,
        domain: domain,
        errorDescription: "An error occured due to missing `data` key in GraphQL query response. Contact developer.paypal.com/support."
    )
}
