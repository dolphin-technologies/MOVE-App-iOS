//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class ApiSdkUserLoginInfo: APIModel {

    public var accessToken: String?

    public var audience: String?

    public var contractId: String?

    public var installationId: String?

    public var jwt: String?

    public var productId: Int?

    public var refreshToken: String?

    public init(accessToken: String? = nil, audience: String? = nil, contractId: String? = nil, installationId: String? = nil, jwt: String? = nil, productId: Int? = nil, refreshToken: String? = nil) {
        self.accessToken = accessToken
        self.audience = audience
        self.contractId = contractId
        self.installationId = installationId
        self.jwt = jwt
        self.productId = productId
        self.refreshToken = refreshToken
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        accessToken = try container.decodeIfPresent("accessToken")
        audience = try container.decodeIfPresent("audience")
        contractId = try container.decodeIfPresent("contractId")
        installationId = try container.decodeIfPresent("installationId")
        jwt = try container.decodeIfPresent("jwt")
        productId = try container.decodeIfPresent("productId")
        refreshToken = try container.decodeIfPresent("refreshToken")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(accessToken, forKey: "accessToken")
        try container.encodeIfPresent(audience, forKey: "audience")
        try container.encodeIfPresent(contractId, forKey: "contractId")
        try container.encodeIfPresent(installationId, forKey: "installationId")
        try container.encodeIfPresent(jwt, forKey: "jwt")
        try container.encodeIfPresent(productId, forKey: "productId")
        try container.encodeIfPresent(refreshToken, forKey: "refreshToken")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? ApiSdkUserLoginInfo else { return false }
      guard self.accessToken == object.accessToken else { return false }
      guard self.audience == object.audience else { return false }
      guard self.contractId == object.contractId else { return false }
      guard self.installationId == object.installationId else { return false }
      guard self.jwt == object.jwt else { return false }
      guard self.productId == object.productId else { return false }
      guard self.refreshToken == object.refreshToken else { return false }
      return true
    }

    public static func == (lhs: ApiSdkUserLoginInfo, rhs: ApiSdkUserLoginInfo) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
