//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension API.PushRest {

    /** Request to update the status of messages displayed in the message center. <br><b>vote:</b> can be of type :<li><b>like</b></li><li><b>dislike</b></li><li>null if not voted</li>. */
    public enum PatchApiV1Messages {

        public static let service = APIService<Response>(id: "patchApiV1Messages", tag: "PushRest", method: "PATCH", path: "/api/v1/messages", hasBody: true, securityRequirements: [SecurityRequirement(type: "timestamp", scopes: []), SecurityRequirement(type: "hash", scopes: [])])

        public final class Request: APIRequest<Response> {

            public struct Options {

                public var xAppContractid: String?

                public var date: String?

                public init(xAppContractid: String? = nil, date: String? = nil) {
                    self.xAppContractid = xAppContractid
                    self.date = date
                }
            }

            public var options: Options

            public var body: ApiUpdateMessagesRequest

            public init(body: ApiUpdateMessagesRequest, options: Options, encoder: RequestEncoder? = nil) {
                self.body = body
                self.options = options
                super.init(service: PatchApiV1Messages.service) { defaultEncoder in
                    return try (encoder ?? defaultEncoder).encode(body)
                }
            }

            /// convenience initialiser so an Option doesn't have to be created
            public convenience init(xAppContractid: String? = nil, date: String? = nil, body: ApiUpdateMessagesRequest) {
                let options = Options(xAppContractid: xAppContractid, date: date)
                self.init(body: body, options: options)
            }

            override var headerParameters: [String: String] {
                var headers: [String: String] = [:]
                if let xAppContractid = options.xAppContractid {
                  headers["x-app-contractid"] = xAppContractid
                }
                if let date = options.date {
                  headers["Date"] = date
                }
                return headers
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = ApiGetMessagesResponse

            /** Request was successful */
            case status200(ApiGetMessagesResponse)

            /** An unexpected error occurred while processing the request. */
            case defaultResponse(statusCode: Int, ApiBaseResponse)

            public var success: ApiGetMessagesResponse? {
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
            public var responseResult: APIResponseResult<ApiGetMessagesResponse, ApiBaseResponse> {
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
                case 200: self = try .status200(decoder.decode(ApiGetMessagesResponse.self, from: data))
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
