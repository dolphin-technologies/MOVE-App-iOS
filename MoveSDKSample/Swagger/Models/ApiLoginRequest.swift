//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class ApiLoginRequest: APIModel {

    public var email: String?

    public var password: String?

    public init(email: String? = nil, password: String? = nil) {
        self.email = email
        self.password = password
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        email = try container.decodeIfPresent("email")
        password = try container.decodeIfPresent("password")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(email, forKey: "email")
        try container.encodeIfPresent(password, forKey: "password")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? ApiLoginRequest else { return false }
      guard self.email == object.email else { return false }
      guard self.password == object.password else { return false }
      return true
    }

    public static func == (lhs: ApiLoginRequest, rhs: ApiLoginRequest) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
