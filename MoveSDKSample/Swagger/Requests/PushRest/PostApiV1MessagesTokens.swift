//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension API.PushRest {

    /** Request to store the device token for an app installation w/ contractId, needed for fcm/apns push messaging<br><b>payloadVersion</b> is used for deciding what push payload can be interpreted correctly by the app version currently used. If not present (null) the old structure is used */
    public enum PostApiV1MessagesTokens {

        public static let service = APIService<Response>(id: "postApiV1MessagesTokens", tag: "PushRest", method: "POST", path: "/api/v1/messages/tokens", hasBody: true, securityRequirements: [SecurityRequirement(type: "timestamp", scopes: []), SecurityRequirement(type: "hash", scopes: [])])

        public final class Request: APIRequest<Response> {

            public struct Options {

                public var xAppContractid: String?

                public var xAppAppid: String?

                public var xAppPlatform: String?

                public init(xAppContractid: String? = nil, xAppAppid: String? = nil, xAppPlatform: String? = nil) {
                    self.xAppContractid = xAppContractid
                    self.xAppAppid = xAppAppid
                    self.xAppPlatform = xAppPlatform
                }
            }

            public var options: Options

            public var body: ApiAddDeviceTokenRequest

            public init(body: ApiAddDeviceTokenRequest, options: Options, encoder: RequestEncoder? = nil) {
                self.body = body
                self.options = options
                super.init(service: PostApiV1MessagesTokens.service) { defaultEncoder in
                    return try (encoder ?? defaultEncoder).encode(body)
                }
            }

            /// convenience initialiser so an Option doesn't have to be created
            public convenience init(xAppContractid: String? = nil, xAppAppid: String? = nil, xAppPlatform: String? = nil, body: ApiAddDeviceTokenRequest) {
                let options = Options(xAppContractid: xAppContractid, xAppAppid: xAppAppid, xAppPlatform: xAppPlatform)
                self.init(body: body, options: options)
            }

            override var headerParameters: [String: String] {
                var headers: [String: String] = [:]
                if let xAppContractid = options.xAppContractid {
                  headers["x-app-contractid"] = xAppContractid
                }
                if let xAppAppid = options.xAppAppid {
                  headers["x-app-appid"] = xAppAppid
                }
                if let xAppPlatform = options.xAppPlatform {
                  headers["x-app-platform"] = xAppPlatform
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