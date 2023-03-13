//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class ApiConvertTimelineTypeRestRequest: APIModel {

    public var data: ApiConvertTimelineTypeRestRequestData?

    public init(data: ApiConvertTimelineTypeRestRequestData? = nil) {
        self.data = data
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        data = try container.decodeIfPresent("data")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(data, forKey: "data")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? ApiConvertTimelineTypeRestRequest else { return false }
      guard self.data == object.data else { return false }
      return true
    }

    public static func == (lhs: ApiConvertTimelineTypeRestRequest, rhs: ApiConvertTimelineTypeRestRequest) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
