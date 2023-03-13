//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension API.MoveUserRest {

    /** Logs the user out of the app. */
    public enum PostApiV1UsersLogout {

        public static let service = APIService<Response>(id: "postApiV1UsersLogout", tag: "MoveUserRest", method: "POST", path: "/api/v1/users/logout", hasBody: true, securityRequirements: [SecurityRequirement(type: "clientName", scopes: []), SecurityRequirement(type: "clientName", scopes: [])])

        public final class Request: APIRequest<Response> {

            public struct Options {

                public var xAppAppid: String?

                public init(xAppAppid: String? = nil) {
                    self.xAppAppid = xAppAppid
                }
            }

            public var options: Options

            public var body: ApiLogoutRequest

            public init(body: ApiLogoutRequest, options: Options, encoder: RequestEncoder? = nil) {
                self.body = body
                self.options = options
                super.init(service: PostApiV1UsersLogout.service) { defaultEncoder in
                    return try (encoder ?? defaultEncoder).encode(body)
                }
            }

            /// convenience initialiser so an Option doesn't have to be created
            public convenience init(xAppAppid: String? = nil, body: ApiLogoutRequest) {
                let options = Options(xAppAppid: xAppAppid)
                self.init(body: body, options: options)
            }

            override var headerParameters: [String: String] {
                var headers: [String: String] = [:]
                if let xAppAppid = options.xAppAppid {
                  headers["x-app-appid"] = xAppAppid
                }
                return headers
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = ApiBaseResponse

            /** Request was successful */
            case status200(ApiBaseResponse)

            /** An unexpected error occurred while processing the request. */
            case defaultResponse(statusCode: Int, ApiBaseResponse)

            public var success: ApiBaseResponse? {
                switch self {
                case .status200(let response): return response
                default: return nil
                }
            }

            public var failure: ApiBaseResponse? {
                switch self {
                case .defaultResponse(_, let response): return response
                default: return nil
                }
            }

            /// either success or failure value. Success is anything in the 200..<300 status code range
            public var responseResult: APIResponseResult<ApiBaseResponse, ApiBaseResponse> {
                if let successValue = success {
                    return .success(successValue)
                } else if let failureValue = failure {
                    return .failure(failureValue)
                } else {
                    fatalError("Response does not have success or failure response")
                }
            }

            public var response: Any {
                switch self {
                case .status200(let response): return response
                case .defaultResponse(_, let response): return response
                }
            }

            public var statusCode: Int {
                switch self {
                case .status200: return 200
                case .defaultResponse(let statusCode, _): return statusCode
                }
            }

            public var successful: Bool {
                switch self {
                case .status200: return true
                case .defaultResponse: return false
                }
            }

            public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
                switch statusCode {
                case 200: self = try .status200(decoder.decode(ApiBaseResponse.self, from: data))
                default: self = try .defaultResponse(statusCode: statusCode, decoder.decode(ApiBaseResponse.self, from: data))
                }
            }

            public var description: String {
                return "\(statusCode) \(successful ? "success" : "failure")"
            }

            public var debugDescription: String {
                var string = description
                let responseString = "\(response)"
                if responseString != "()" {
                    string += "\n\(responseString)"
                }
                return string
            }
        }
    }
}
