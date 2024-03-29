//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public enum APIClientError: Error {
	case serverError(code: Int, message: String?)
    case unexpectedStatusCode(statusCode: Int, data: Data)
    case decodingError(DecodingError)
    case requestEncodingError(Error)
    case validationError(Error)
    case networkError(Error)
    case unknownError(Error)

    public var name:String {
        switch self {
		case .serverError: return "Server Error"
        case .unexpectedStatusCode: return "Unexpected status code"
        case .decodingError: return "Decoding error"
        case .validationError: return "Request validation failed"
        case .requestEncodingError: return "Request encoding failed"
        case .networkError: return "Network error"
        case .unknownError: return "Unknown error"
        }
    }
}

extension APIClientError: CustomStringConvertible {

    public var description:String {
        switch self {
		case let .serverError(code, message):
			if let message = message {
				return "\(message)"
			} else {
				return "\(code)"
			}
        case let .unexpectedStatusCode(statusCode, _): return "\(name): \(statusCode)"
        case let .decodingError(error): return "\(name): \(error.localizedDescription)\n\(error)"
        case let .validationError(error): return "\(name): \(error.localizedDescription)"
        case let .requestEncodingError(error): return "\(name): \(error)"
        case let .networkError(error): return "\(name): \(error.localizedDescription)"
        case let .unknownError(error): return "\(name): \(error.localizedDescription)"
        }
    }
}
