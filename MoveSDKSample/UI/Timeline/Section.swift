/*
 *  Copyright 2023 Dolphin Technologies GmbH
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *       http:*www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 * /
 */

import CoreLocation
import Foundation
import simd

struct Section {
	let info: TripDetails.Location

	let start: SIMD2<CLLocationDistance>
	let end: SIMD2<CLLocationDistance>
	let direction: SIMD2<CLLocationDistance>
	let length: CLLocationDistance

	init(start loc0: TripDetails.Location, end loc1: TripDetails.Location) {
		info = loc0
		start = loc0.coordinate.simd
		end = loc1.coordinate.simd
		let vector = SIMD2(end.x - start.x, end.y - start.y)
		/* length of the segment */
		length = simd_length(vector)
		/* direction vector for the segment */
		direction = simd_normalize(vector)
	}

	static func get(from tripDetails: TripDetails) -> [Section] {
		var sections: [Section] = []
		var prev: TripDetails.Location?

		for location in tripDetails.locations {
			if let prev = prev {
				sections.append(Section(start: prev, end: location))
			}
			prev = location
		}
		return sections
	}

	static func find(coordinate: CLLocationCoordinate2D, from details: TripDetails) -> (TripDetails.Location?, CLLocationCoordinate2D) {

		let point = coordinate.simd
		var target: TripDetails.Location?

		var intersection = coordinate
		let sections = Section.get(from: details)

		var distance = Double.infinity
		for sect in sections {
			let p = sect.intersection(from: point)
			let offset = p - point
			let dist = simd_dot(offset, offset)
			if dist <= distance {
				distance = dist
				target = sect.info
				intersection = CLLocationCoordinate2D(latitude: p.x, longitude: p.y)
			}
		}

		return (target, intersection)
	}

	func intersection(from point: SIMD2<CLLocationDistance>) -> SIMD2<CLLocationDistance> {
		/* t = v • p - v • start
		 * 0 <= t < length */
		var t = simd_dot(direction, point) - simd_dot(direction, start)

		if t < 0.0 {
			t = 0.0
		} else if t > length {
			/* tolerance */
			t = length
		}

		return start + direction * t
	}
}

extension CLLocationCoordinate2D {
	var simd: SIMD2<CLLocationDistance> {
		return SIMD2<CLLocationDistance>(latitude, longitude)
	}
}
