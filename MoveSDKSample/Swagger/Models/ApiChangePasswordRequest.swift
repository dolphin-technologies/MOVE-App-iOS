//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class ApiChangePasswordRequest: APIModel {

    public var newPassword: String?

    public var password: String?

    public init(newPassword: String? = nil, password: String? = nil) {
        self.newPassword = newPassword
        self.password = password
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        newPassword = try container.decodeIfPresent("newPassword")
        password = try container.decodeIfPresent("password")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(newPassword, forKey: "newPassword")
        try container.encodeIfPresent(password, forKey: "password")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? ApiChangePasswordRequest else { return false }
      guard self.newPassword == object.newPassword else { return false }
      guard self.password == object.password else { return false }
      return true
    }

    public static func == (lhs: ApiChangePasswordRequest, rhs: ApiChangePasswordRequest) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
