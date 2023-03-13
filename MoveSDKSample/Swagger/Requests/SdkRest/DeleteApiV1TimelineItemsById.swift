//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension API.SdkRest {

    public enum DeleteApiV1TimelineItemsById {

        public static let service = APIService<Response>(id: "deleteApiV1TimelineItemsById", tag: "SdkRest", method: "DELETE", path: "/api/v1/timeline/items/{id}", hasBody: false, securityRequirements: [SecurityRequirement(type: "hash", scopes: []), SecurityRequirement(type: "hash", scopes: [])])

        public final class Request: APIRequest<Response> {

            public struct Options {

                public var xAppContractid: String?

                public var acceptLanguage: String?

                public var id: Int

                public var reasonId: Int?

                public init(xAppContractid: String? = nil, acceptLanguage: String? = nil, id: Int, reasonId: Int? = nil) {
                    self.xAppContractid = xAppContractid
                    self.acceptLanguage = acceptLanguage
                    self.id = id
                    self.reasonId = reasonId
                }
            }

            public var options: Options

            public init(options: Options) {
                self.options = options
                super.init(service: DeleteApiV1TimelineItemsById.service)
            }

            /// convenience initialiser so an Option doesn't have to be created
            public convenience init(xAppContractid: String? = nil, acceptLanguage: String? = nil, id: Int, reasonId: Int? = nil) {
                let options = Options(xAppContractid: xAppContractid, acceptLanguage: acceptLanguage, id: id, reasonId: reasonId)
                self.init(options: options)
            }

            public override var path: String {
                return super.path.replacingOccurrences(of: "{" + "id" + "}", with: "\(self.options.id)")
            }

            public override var queryParameters: [String: Any] {
                var params: [String: Any] = [:]
                if let reasonId = options.reasonId {
                  params["reasonId"] = reasonId
                }
                return params
            }

            override var headerParameters: [String: String] {
                var headers: [String: String] = [:]
                if let xAppContractid = options.xAppContractid {
                  headers["x-app-contractid"] = xAppContractid
                }
                if let acceptLanguage = options.acceptLanguage {
                  headers["Accept-Language"] = acceptLanguage
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
