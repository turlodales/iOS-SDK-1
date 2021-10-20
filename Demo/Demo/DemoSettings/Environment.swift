import PaymentsCore

enum Environment: String {
    case sandbox
    case production

    var baseURL: String {
        switch self {
        case .sandbox:
            return "https://api.sandbox.paypal.com"
        case .production:
            return "TODO"
        }
    }

    var paypalSDKEnvironment: PaymentsCore.Environment {
        switch self {
        case .sandbox:
            return .sandbox
        case .production:
            return .production
        }
    }
}
