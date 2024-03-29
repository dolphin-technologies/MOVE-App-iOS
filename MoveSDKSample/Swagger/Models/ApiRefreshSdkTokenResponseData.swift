//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class ApiRefreshSdkTokenResponseData: APIModel {

    public var sdkUserLoginInfo: ApiSdkUserLoginInfo?

    public init(sdkUserLoginInfo: ApiSdkUserLoginInfo? = nil) {
        self.sdkUserLoginInfo = sdkUserLoginInfo
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        sdkUserLoginInfo = try container.decodeIfPresent("sdkUserLoginInfo")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(sdkUserLoginInfo, forKey: "sdkUserLoginInfo")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? ApiRefreshSdkTokenResponseData else { return false }
      guard self.sdkUserLoginInfo == object.sdkUserLoginInfo else { return false }
      return true
    }

    public static func == (lhs: ApiRefreshSdkTokenResponseData, rhs: ApiRefreshSdkTokenResponseData) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
