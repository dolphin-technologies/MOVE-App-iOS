//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class ApiTripRemovalReasonsResponseData: APIModel {

    public var reasons: [ApiTripRemovalReason]?

    public init(reasons: [ApiTripRemovalReason]? = nil) {
        self.reasons = reasons
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        reasons = try container.decodeArrayIfPresent("reasons")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(reasons, forKey: "reasons")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? ApiTripRemovalReasonsResponseData else { return false }
      guard self.reasons == object.reasons else { return false }
      return true
    }

    public static func == (lhs: ApiTripRemovalReasonsResponseData, rhs: ApiTripRemovalReasonsResponseData) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
