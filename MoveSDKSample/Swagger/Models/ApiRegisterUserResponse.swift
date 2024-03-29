//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class ApiRegisterUserResponse: ApiBaseResponse {

    public var data: ApiLogin?

    public init(id: Int? = nil, serverIsoTime: String? = nil, serverTs: Int? = nil, status: ApiStatus? = nil, data: ApiLogin? = nil) {
        self.data = data
        super.init(id: id, serverIsoTime: serverIsoTime, serverTs: serverTs, status: status)
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        data = try container.decodeIfPresent("data")
        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(data, forKey: "data")
        try super.encode(to: encoder)
    }

    override public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? ApiRegisterUserResponse else { return false }
      guard self.data == object.data else { return false }
      return super.isEqual(to: object)
    }
}
