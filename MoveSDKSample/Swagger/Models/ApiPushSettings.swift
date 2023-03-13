//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class ApiPushSettings: APIModel {

    public var settings: [String: Bool]?

    public init(settings: [String: Bool]? = nil) {
        self.settings = settings
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        settings = try container.decodeIfPresent("settings")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(settings, forKey: "settings")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? ApiPushSettings else { return false }
      guard self.settings == object.settings else { return false }
      return true
    }

    public static func == (lhs: ApiPushSettings, rhs: ApiPushSettings) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
