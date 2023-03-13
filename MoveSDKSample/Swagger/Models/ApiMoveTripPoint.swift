//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class ApiMoveTripPoint: APIModel {

    public var altitude: Int?

    public var colour: ApiColour?

    public var isoTime: String?

    public var lat: String?

    public var lon: String?

    public var roadLat: String?

    public var roadLon: String?

    public var speed: Int?

    public var speedLimit: Int?

    public var wayType: String?

    public init(altitude: Int? = nil, colour: ApiColour? = nil, isoTime: String? = nil, lat: String? = nil, lon: String? = nil, roadLat: String? = nil, roadLon: String? = nil, speed: Int? = nil, speedLimit: Int? = nil, wayType: String? = nil) {
        self.altitude = altitude
        self.colour = colour
        self.isoTime = isoTime
        self.lat = lat
        self.lon = lon
        self.roadLat = roadLat
        self.roadLon = roadLon
        self.speed = speed
        self.speedLimit = speedLimit
        self.wayType = wayType
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        altitude = try container.decodeIfPresent("altitude")
        colour = try container.decodeIfPresent("colour")
		isoTime = try container.decodeAnyIfPresent("time")

		//        isoTime = try container.decodeAnyIfPresent("isoTime")
        lat = try container.decodeIfPresent("lat")
        lon = try container.decodeIfPresent("lon")
        roadLat = try container.decodeIfPresent("roadLat")
        roadLon = try container.decodeIfPresent("roadLon")
        speed = try container.decodeIfPresent("speed")
        speedLimit = try container.decodeIfPresent("speedLimit")
        wayType = try container.decodeIfPresent("wayType")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(altitude, forKey: "altitude")
        try container.encodeIfPresent(colour, forKey: "colour")
		try container.encodeIfPresent(isoTime, forKey: "time")
//        try container.encodeIfPresent(isoTime, forKey: "isoTime")
        try container.encodeIfPresent(lat, forKey: "lat")
        try container.encodeIfPresent(lon, forKey: "lon")
        try container.encodeIfPresent(roadLat, forKey: "roadLat")
        try container.encodeIfPresent(roadLon, forKey: "roadLon")
        try container.encodeIfPresent(speed, forKey: "speed")
        try container.encodeIfPresent(speedLimit, forKey: "speedLimit")
        try container.encodeIfPresent(wayType, forKey: "wayType")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? ApiMoveTripPoint else { return false }
      guard self.altitude == object.altitude else { return false }
      guard self.colour == object.colour else { return false }
	  guard self.isoTime == object.isoTime else { return false }
      guard self.lat == object.lat else { return false }
      guard self.lon == object.lon else { return false }
      guard self.roadLat == object.roadLat else { return false }
      guard self.roadLon == object.roadLon else { return false }
      guard self.speed == object.speed else { return false }
      guard self.speedLimit == object.speedLimit else { return false }
      guard self.wayType == object.wayType else { return false }
      return true
    }

    public static func == (lhs: ApiMoveTripPoint, rhs: ApiMoveTripPoint) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}