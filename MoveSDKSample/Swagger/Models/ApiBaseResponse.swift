//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class ApiBaseResponse: APIModel {

    public var id: Int?

    public var serverIsoTime: String?

    public var serverTs: Int?

    public var status: ApiStatus?

    public init(id: Int? = nil, serverIsoTime: String? = nil, serverTs: Int? = nil, status: ApiStatus? = nil) {
        self.id = id
        self.serverIsoTime = serverIsoTime
        self.serverTs = serverTs
        self.status = status
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        id = try container.decodeIfPresent("id")
        serverIsoTime = try container.decodeIfPresent("serverIsoTime")
        serverTs = try container.decodeIfPresent("serverTs")
        status = try container.decodeIfPresent("status")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(id, forKey: "id")
        try container.encodeIfPresent(serverIsoTime, forKey: "serverIsoTime")
        try container.encodeIfPresent(serverTs, forKey: "serverTs")
        try container.encodeIfPresent(status, forKey: "status")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? ApiBaseResponse else { return false }
      guard self.id == object.id else { return false }
	  guard self.serverIsoTime == object.serverIsoTime else { return false }
      guard self.serverTs == object.serverTs else { return false }
      guard self.status == object.status else { return false }
      return true
    }

    public static func == (lhs: ApiBaseResponse, rhs: ApiBaseResponse) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
